#' Map Fecal Indicator Bacteria matrix results by year
#'
#' @param fibdata input data frame as returned by \code{\link{read_importfib}},  \code{\link{read_importentero}}, or \code{\link{read_importwqp}}, see details
#' @param yrsel numeric value indicating the year to map
#' @param areasel vector of bay segment or area names to include, see details
#' @param indic character for choice of fecal indicator. Allowable options are \code{fcolif} for fecal coliform, or \code{entero} for Enterococcus. A numeric column in the data frame must have this name.
#' @param threshold optional numeric for threshold against which to calculate exceedances for the indicator bacteria of choice. If not provided, defaults to 400 for \code{fcolif} and 130 for \code{entero}.
#' @param lagyr numeric for year lag to calculate categories, see details
#' @param subset_wetdry character, subset data frame to only wet or dry samples as defined by \code{wet_threshold} and \code{temporal_window}? Defaults to \code{"all"}, which will not subset. If \code{"wet"} or \code{"dry"} is specified, \code{\link{anlz_fibwetdry}} is called using the further specified parameters, and the data frame is subsetted accordingly.
#' @param precipdata input data frame as returned by \code{\link{read_importrain}}. columns should be: station, date (yyyy-mm-dd), rain (in inches). The object \code{\link{catchprecip}} has this data from 1995-2023 for select Enterococcus stations. If \code{NULL}, defaults to \code{\link{catchprecip}}.
#' @param temporal_window numeric; required if \code{subset_wetdry} is not \code{"all"}. number of days precipitation should be summed over (1 = day of sample only; 2 = day of sample + day before; etc.)
#' @param wet_threshold  numeric; required if \code{subset_wetdry} is not \code{"all"}. inches accumulated through the defined temporal window, above which a sample should be defined as being from a 'wet' time period
#' @param listout logical to return a list of simple feature objects for the data used in the \code{leaflet} map, default \code{FALSE}
#' @param warn logical to print warnings about stations with insufficient data, default \code{TRUE}
#'
#' @return A \code{leaflet} map for the selected year and area showing station matrix scores if \code{listout = FALSE} (default).  Bay segment scores are also shown if the input data are not from EPCHC. A list of simple feature objects is returned if \code{listout = TRUE}.
#'
#' @details Placing the mouse cursor over an item on the map will reveal additional information about a segment or station.
#'
#' If the input to \code{fibdata} is from EPCHC (from \code{\link{read_importfib}}), valid entries for \code{areasel} include 'Alafia River', 'Hillsborough River', 'Big Bend', 'Cockroach Bay', 'East Lake Outfall', 'Hillsborough Bay', 'Little Manatee River', 'Lower Tampa Bay', 'McKay Bay', 'Middle Tampa Bay', 'Old Tampa Bay', 'Palm River', 'Tampa Bypass Canal', and 'Valrico Lake'.  If the input data is not from EPCHC (from \code{\link{read_importentero}}), valid entries for \code{areasel} include 'OTB', 'HB', 'MTB', 'LTB', 'BCB', and 'MR'.
#'
#' Input from \code{\link{read_importwqp}} for Manatee County (21FLMANA_WQX) FIB data can also be used.  The function has not been tested for other organizations.  Valid entries for \code{areasel} include \code{"Big Slough"}, \code{"Bowlees Creek"}, \code{"Braden River"}, \code{"Bud Slough"}, \code{"Clay Gully"}, \code{"Frog Creek"}, \code{"Gap Creek"}, \code{"Little Manatee River"}, \code{"Lower Tampa Bay"}, \code{"Manatee River"}, \code{"Mcmullen Creek"}, \code{"Mud Lake Slough"}, \code{"Myakka River"}, \code{"Palma Sola Bay"}, or \code{"Piney Point Creek"}.
#'
#' Bay segment matrix categories can be shown if input data are from \code{\link{read_importentero}}).  Stations for these data were chosen specifically as downstream endpoints for each bay segment, whereas the other datasets are not appropriate for estimating bay segment outcomes.
#'
#' @concept show
#'
#' @seealso \code{\link{anlz_fibmatrix}} for details on the categories
#' @export
#'
#' @examples
#' # non-EPCHC, non Manatee County data
#' show_fibmatmap(enterodata, yrsel = 2020, indic = 'entero', areasel = 'OTB')
#'
#' # EPCHC data
#' show_fibmatmap(fibdata, yrsel = 2016, indic = 'fcolif',
#'    areasel = c("Hillsborough River", "Alafia River"))
#'
#' # Manatee County data
#' show_fibmatmap(mancofibdata, yrsel = 2020, indic = 'fcolif', areasel = 'Manatee River')
show_fibmatmap <- function(fibdata, yrsel, areasel, indic, threshold = NULL,
                           lagyr = 3, subset_wetdry = c("all", "wet", "dry"), precipdata = NULL,
                           temporal_window = NULL, wet_threshold = NULL, listout = FALSE,
                           warn = TRUE){

  # get categories
  cols <- c('#2DC938', '#E9C318', '#EE7600', '#CC3231', '#800080')
  names(cols) <- c('A', 'B', 'C', 'D', 'E')

  # check if epchc data
  isepchc <- exists("epchc_station", fibdata)

  # check if manco data
  ismanco <- exists("manco_station", fibdata)

  if(!isepchc & !ismanco){

    # includes bay segment check
    tomapseg <- anlz_fibmatrix(fibdata, yrrng = c(yrsel - lagyr, yrsel), stas = NULL, bay_segment = areasel,
                             indic = indic, threshold = threshold, lagyr = lagyr,
                             subset_wetdry = subset_wetdry, precipdata = precipdata,
                             temporal_window = temporal_window, wet_threshold = wet_threshold ,
                             warn = warn) %>%
      dplyr::filter(!is.na(cat)) %>%
      dplyr::filter(yr == !!yrsel) %>%
      dplyr::inner_join(tbsegdetail, ., by = c('bay_segment' = 'grp')) %>%
      dplyr::mutate(
        lab = paste0('<html>Area: ', long_name, '<br>Category: ', cat),
        col = as.character(cols[cat])
      )

    stas <- fibdata %>%
      dplyr::filter(bay_segment %in% !!areasel) %>%
      dplyr::filter(yr <= !!yrsel & yr >= (!!yrsel - !!lagyr)) %>%
      dplyr::select(grp = station, area = long_name) %>%
      dplyr::distinct()

    tomapsta <- anlz_fibmatrix(fibdata, yrrng = c(yrsel - lagyr, yrsel), stas = stas$grp, bay_segment = NULL,
                             indic = indic, threshold = threshold, lagyr = lagyr,
                             subset_wetdry = subset_wetdry, precipdata = precipdata,
                             temporal_window = temporal_window, wet_threshold = wet_threshold,
                             warn = warn)

  }

  if(isepchc){

    # check bay segment
    areas <- c('Alafia River', 'Hillsborough River', 'Big Bend', 'Cockroach Bay',
                'East Lake Outfall', 'Hillsborough Bay', 'Little Manatee River', 'Lower Tampa Bay',
                'McKay Bay', 'Middle Tampa Bay', 'Old Tampa Bay', 'Palm River', 'Tampa Bypass Canal',
                'Valrico Lake')

    chk <- !areasel %in% areas
    if(any(chk)){
      stop('Invalid value(s) for areasel: ', paste(areasel[chk], collapse = ', '))
    }

    stas <- fibdata %>%
      dplyr::filter(area %in% !!areasel) %>%
      dplyr::filter(yr <= !!yrsel & yr >= (!!yrsel - !!lagyr)) %>%
      dplyr::select(grp = epchc_station, area) %>%
      dplyr::distinct()

    tomapsta <- anlz_fibmatrix(fibdata, yrrng = c(yrsel - lagyr, yrsel), stas = stas$grp, bay_segment = NULL,
                             indic = indic, threshold = threshold, lagyr = lagyr,
                             subset_wetdry = subset_wetdry, precipdata = precipdata,
                             temporal_window = temporal_window, wet_threshold = wet_threshold,
                             warn = warn)

    tomapseg <- NULL

  }

  if(ismanco){

    # check areas
    areas <- c("Big Slough", "Bowlees Creek", "Braden River", "Bud Slough",
               "Clay Gully", "Frog Creek", "Gap Creek", "Little Manatee River",
               "Lower Tampa Bay", "Manatee River", "Mcmullen Creek", "Mud Lake Slough",
               "Myakka River", "Palma Sola Bay", "Piney Point Creek")

    chk <- !areasel %in% areas
    if(any(chk)){
      stop('Invalid value(s) for areasel: ', paste(areasel[chk], collapse = ', '))
    }

    stas <- fibdata %>%
      dplyr::filter(area %in% !!areasel) %>%
      dplyr::filter(yr <= !!yrsel & yr >= (!!yrsel - !!lagyr)) %>%
      dplyr::select(grp = manco_station, area) %>%
      dplyr::distinct()

    tomapsta <- anlz_fibmatrix(fibdata, yrrng = c(yrsel - lagyr, yrsel), stas = stas$grp, bay_segment = NULL,
                               indic = indic, threshold = threshold, lagyr = lagyr,
                               subset_wetdry = subset_wetdry, precipdata = precipdata,
                               temporal_window = temporal_window, wet_threshold = wet_threshold,
                               warn = warn)

    tomapseg <- NULL

  }

  # create custom icon list for fib matrix categories
  icons <- util_fibicons('fibmat')

  # FIB levels
  levs <- util_fiblevs()

  # make character to join
  stas <- stas %>%
    dplyr::mutate(
      grp = as.character(grp)
    )

  # subset year, remove NA cat, add labels
  tomapsta <- tomapsta %>%
    dplyr::filter(!is.na(cat)) %>%
    dplyr::filter(yr == !!yrsel) %>%
    dplyr::mutate(grp = as.character(grp)) %>%
    dplyr::left_join(stas, by = 'grp') %>%
    sf::st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE) %>%
    dplyr::mutate(
      cat = factor(cat, levels = levs$fibmatlev),
      lab = paste0('<html>Station Number: ', grp, '<br>Area: ', area, '<br>Category: ', cat)
    )

  # return data instead of leaflet
  if(listout){

    out <- list(
      icons = icons,
      tomapsta = tomapsta,
      tomapseg = tomapseg
    )

    return(out)

  }

  # legend
  leg <- tibble::tibble(
    src = paste0('https://github.com/tbep-tech/tbeptools/blob/master/inst/', basename(sapply(icons, `[[`, 1)), '?raw=true'),
    brk = levs$fibmatlbs
  ) %>%
    tidyr::unite('val', src, brk, sep = "' style='width:10px;height:10px;'> ") %>%
    dplyr::mutate(
      val = paste0("<img src='", val)
    ) %>%
    dplyr::pull(val) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>Report card<br/>categories</b><br/>', .)


  # create map
  out <- util_map(tomapsta) %>%
    leaflet::addMarkers(
      data = tomapsta,
      lng = ~Longitude,
      lat = ~Latitude,
      icon = ~icons[as.numeric(cat)],
      label = ~lapply(as.list(lab), util_html)
    ) %>%
    leaflet::addControl(html = leg, position = 'topright')

  # add bay segments if not epchc
  if(!isepchc & !ismanco){

    out <- out %>%
      leaflet::addPolygons(
        data = tomapseg,
        fillColor = ~I(col),
        fillOpacity = 0.5,
        color = 'black',
        weight = 1,
        label = ~lapply(as.list(lab), util_html)
      )

  }

  return(out)

}

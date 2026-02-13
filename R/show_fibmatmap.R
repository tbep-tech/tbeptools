#' Map Fecal Indicator Bacteria matrix results by year
#'
#' @param fibdata input data frame as returned by \code{\link{read_importfib}},  \code{\link{read_importentero}}, or \code{\link{read_importwqp}}, see details
#' @param yrsel numeric value indicating the year to map
#' @param areasel vector of bay segment or area names to include, see details
#' @param lagyr numeric for year lag to calculate categories, see details
#' @param subset_wetdry character, subset data frame to only wet or dry samples as defined by \code{wet_threshold} and \code{temporal_window}? Defaults to \code{"all"}, which will not subset. If \code{"wet"} or \code{"dry"} is specified, \code{\link{anlz_fibwetdry}} is called using the further specified parameters, and the data frame is subsetted accordingly.
#' @param precipdata input data frame as returned by \code{\link{read_importrain}}. columns should be: station, date (yyyy-mm-dd), rain (in inches). The object \code{\link{catchprecip}} has this data from 1995-2023 for select Enterococcus stations. If \code{NULL}, defaults to \code{\link{catchprecip}}.
#' @param temporal_window numeric; required if \code{subset_wetdry} is not \code{"all"}. number of days precipitation should be summed over (1 = day of sample only; 2 = day of sample + day before; etc.)
#' @param wet_threshold  numeric; required if \code{subset_wetdry} is not \code{"all"}. inches accumulated through the defined temporal window, above which a sample should be defined as being from a 'wet' time period
#' @param addsta logical to add station labels to the map, default \code{FALSE}
#' @param listout logical to return a list of simple feature objects for the data used in the \code{leaflet} map, default \code{FALSE}
#' @param warn logical to print warnings about stations with insufficient data, default \code{TRUE}
#'
#' @return A \code{leaflet} map for the selected year and area showing station matrix scores if \code{listout = FALSE} (default).  Bay segment scores are also shown if the input data are not from EPCHC. A list of simple feature objects is returned if \code{listout = TRUE}.
#'
#' @details Placing the mouse cursor over an item on the map will reveal additional information about a segment or station.
#'
#' If the input is from EPCHC (from \code{\link{read_importfib}}, i.e., \code{\link{fibdata}}), valid entries for \code{areasel} include 'Alafia River', 'Hillsborough River', 'Big Bend', 'Cockroach Bay', 'East Lake Outfall', 'Hillsborough Bay', 'Little Manatee River', 'Lower Tampa Bay', 'McKay Bay', 'Middle Tampa Bay', 'Old Tampa Bay', 'Palm River', 'Tampa Bypass Canal', and 'Valrico Lake'.  If the input data is from \code{\link{read_importentero}} (i.e., \code{\link{enterodata}})), valid entries for \code{areasel} include 'OTB', 'HB', 'MTB', 'LTB', 'BCB', and 'MR'.  If the input is from \code{\link{read_importwqp}} for Manatee County (21FLMANA_WQX, \code{\link{mancofibdata}}), Pasco County (21FLPASC_WQX, \code{\link{pascofibdata}}), Polk County (21FLPOLK_WQX, \code{\link{polcofibdata}}), or Hillsborough County Environmental Services Division (21FLHESD_WQX, \code{\link{hcesdfibdata}}) valid entries for \code{areasel} are any that are present in the \code{area} column for the respective input datasets.
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
#' show_fibmatmap(enterodata, yrsel = 2020, areasel = 'OTB')
#'
#' # EPCHC data
#' show_fibmatmap(fibdata, yrsel = 2016,
#'    areasel = c("Hillsborough River", "Alafia River"))
#'
#' # Manatee County data
#' show_fibmatmap(mancofibdata, yrsel = 2020,  areasel = 'Manatee River')
show_fibmatmap <- function(fibdata, yrsel, areasel,
                           lagyr = 3, subset_wetdry = c("all", "wet", "dry"), precipdata = NULL,
                           temporal_window = NULL, wet_threshold = NULL, addsta = FALSE, listout = FALSE,
                           warn = TRUE){

  # get categories
  cols <- c('#2DC938', '#E9C318', '#EE7600', '#CC3231', '#800080')
  names(cols) <- c('A', 'B', 'C', 'D', 'E')

  # check if epchc data
  isepchc <- exists("epchc_station", fibdata)

  # check if manco, pasco, polco, or hcesd data
  isother <- any(grepl('^manco|^pasco|^polco|^hcesd', names(fibdata)))

  if(!isepchc & !isother){

    # includes bay segment check
    tomapsegcat <- anlz_fibmatrix(fibdata, yrrng = c(yrsel - lagyr, yrsel), stas = NULL, bay_segment = areasel,
                             lagyr = lagyr,
                             subset_wetdry = subset_wetdry, precipdata = precipdata,
                             temporal_window = temporal_window, wet_threshold = wet_threshold ,
                             warn = warn) %>%
      dplyr::filter(!is.na(cat)) %>%
      dplyr::filter(yr == !!yrsel)

    bayseg <- tbsegdetail %>%
      dplyr::filter(bay_segment %in% !!areasel)

    stas <- fibdata %>%
      dplyr::filter(bay_segment %in% !!areasel) %>%
      dplyr::filter(yr <= !!yrsel & yr >= (!!yrsel - !!lagyr)) %>%
      dplyr::select(grp = station, area = long_name) %>%
      dplyr::distinct()

    tomapsta <- anlz_fibmatrix(fibdata, yrrng = c(yrsel - lagyr, yrsel), stas = stas$grp, bay_segment = NULL,
                             lagyr = lagyr,
                             subset_wetdry = subset_wetdry, precipdata = precipdata,
                             temporal_window = temporal_window, wet_threshold = wet_threshold,
                             warn = warn)
    
    tomapseg <- dbasin[tomapsta %>%
        sf::st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE),
      ] %>%
      dplyr::select(long_name, bay_segment, geometry) |> 
      dplyr::group_by(long_name, bay_segment) |>
      dplyr::summarise(geometry = sf::st_union(geometry), .groups = 'drop') |>
      dplyr::left_join(tomapsegcat, by = c('bay_segment' = 'grp')) %>%
      dplyr::mutate(
        lab = paste0('<html>Area: ', long_name, '<br>Category: ', cat),
        col = as.character(cols[cat])
      )

  }

  if(isepchc){

    # check bay segment
    areas <- c('Alafia River', 'Hillsborough River', 'Cockroach Bay',
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
      dplyr::filter(
        (class %in% c('3M', '2') & !is.na(entero)) | (class %in% c('3F', '1') & !is.na(ecoli))
      ) %>%
      dplyr::select(grp = epchc_station, area) %>%
      dplyr::distinct()

    tomapsta <- anlz_fibmatrix(fibdata, yrrng = c(yrsel - lagyr, yrsel), stas = stas$grp, bay_segment = NULL,
                             lagyr = lagyr,
                             subset_wetdry = subset_wetdry, precipdata = precipdata,
                             temporal_window = temporal_window, wet_threshold = wet_threshold,
                             warn = warn)

    tomapseg <- NULL

  }

  if(isother){

    # check areas
    areas <- sort(unique(fibdata$area))

    chk <- !areasel %in% areas
    if(any(chk)){
      stop('Invalid value(s) for areasel: ', paste(areasel[chk], collapse = ', '))
    }

    stas <- fibdata %>%
      dplyr::filter(area %in% !!areasel) %>%
      dplyr::filter(yr <= !!yrsel & yr >= (!!yrsel - !!lagyr)) %>%
      dplyr::filter(
        (class == 'Fresh' & var == 'ecoli') | (class == 'Marine' & var == 'entero')
      ) %>%
      dplyr::rename_with(~ "grp", dplyr::matches("^(manco|pasco|polco|hcesd)_station$")) %>%
      dplyr::select(grp, area) %>%
      dplyr::distinct()

    tomapsta <- anlz_fibmatrix(fibdata, yrrng = c(yrsel - lagyr, yrsel), stas = stas$grp, bay_segment = NULL,
                               lagyr = lagyr,
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
    dplyr::filter(yr == !!yrsel)

  # stop if no data
  if(nrow(tomapsta) == 0){
    stop('Insufficient data for lagyr')
  }

  tomapsta <- tomapsta %>%
    dplyr::mutate(grp = as.character(grp)) %>%
    dplyr::left_join(stas, by = 'grp') %>%
    sf::st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE) %>%
    dplyr::mutate(
      cat = factor(cat, levels = levs$fibmatlev),
      lab = paste0('<html>Station Number: ', grp, '<br>Class: ', class, '<br>Area: ', area, '<br>Category: ', cat)
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
  if(!isepchc & !isother){

    out <- out %>%
      leaflet::addPolygons(
        data = bayseg,
        fillColor = 'transparent',
        color = 'black',
        weight = 2,
        label = ~lapply(as.list(long_name), util_html)
      ) %>%
      leaflet::addPolygons(
        data = tomapseg,
        fillColor = ~I(col),
        fillOpacity = 0.5,
        color = 'black',
        weight = 1,
        label = ~lapply(as.list(lab), util_html)
      )

  }

  # add station labels
  if(addsta){

    out <- out %>%
      leaflet::addLabelOnlyMarkers(
        data = tomapsta,
        lng = ~Longitude,
        lat = ~Latitude,
        label = ~grp,
        labelOptions = leaflet::labelOptions(noHide = TRUE, textOnly = TRUE)
      )

  }

  return(out)

}

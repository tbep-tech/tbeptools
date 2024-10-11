#' Assign threshold categories to Fecal Indicator Bacteria (FIB) data
#'
#' @param fibdata input FIB \code{data.frame} as returned by \code{\link{read_importfib}} or \code{\link{read_importwqp}}, see details
#' @param yrsel optional numeric value to filter output by years in \code{fibdata}
#' @param mosel optional numeric value to filter output by month in \code{fibdata}
#' @param areasel optional character string to filter output by stations in the \code{area} column of \code{fibdata}, see details
#' @param assf logical indicating if the data are further processed as a simple features object with additional columns for \code{\link{show_fibmap}}
#'
#' @details This function is used to create FIB categories for mapping using \code{\link{show_fibmap}}.  Categories based on relevant thresholds are assigned to each observation.  The categories are specific to E. coli or Enterococcus and are assigned based on the station class as freshwater (\code{class} as 1 or 3F) or marine (\code{class} as 2 or 3M), respectively.  A station is categorized into one of four ranges defined by the thresholds as noted in the \code{cat} column of the output, with corresponding colors appropriate for each range as noted in the \code{col} column of the output.
#'
#' Data from Manatee County (21FLMANA_WQX) returned by \code{\link{read_importwqp}} can be used with this function.  Data from other organization have returned by this function have not been tested.
#'
#' The \code{areasel} argument can indicate valid entries in the \code{area} column of \code{fibdata} (from \code{\link{read_importfib}}) or \code{mancofibdata} (from \code{\link{read_importwqp}}).  For example, use either \code{"Alafia River"} or \code{"Hillsborough River"} for the corresponding river basins, where rows in  \code{fibdata} are filtered based on the the selection.  All stations are returned if this argument is set as \code{NULL} (default). The Alafia River basin includes values in the \code{area} column of \code{fibdata} as \code{"Alafia River"} and \code{"Alafia River Tributary"}.  The Hillsborough River basin includes values in the \code{area} column of \code{fibdata} as \code{"Hillsborough River"}, \code{"Hillsborough River Tributary"}, \code{"Lake Thonotosassa"}, \code{"Lake Thonotosassa Tributary"}, and \code{"Lake Roberta"}.  Not all areas may be present based on the selection.
#'
#' All valid options for \code{areasel} for \code{fibdata} include \code{"Alafia River"}, \code{"Hillsborough River"}, \code{"Big Bend"}, \code{"Cockroach Bay"}, \code{"East Lake Outfall"}, \code{"Hillsborough Bay"}, \code{"Little Manatee"}, \code{"Lower Tampa Bay"}, \code{"McKay Bay"}, \code{"Middle Tampa Bay"}, \code{"Old Tampa Bay"}, \code{"Palm River"}, \code{"Tampa Bypass Canal"}, or \code{"Valrico Lake"}. One to any of the options can be used.
#'
#' Valid entries for \code{areasel} for \code{mancofibdata} include 'Big Slough', 'Bowlees Creek', 'Braden River', 'Bud Slough',  'Cedar Creek', 'Clay Gully', 'Cooper Creek', 'Curiosity Creek', 'Frog Creek', 'Gamble Creek', 'Gap Creek', 'Gates Creek', 'Gilley Creek', 'Hickory Hammock Creek', 'Lake Manatee', 'Little Manatee River', 'Lower Manatee River', 'Lower Tampa Bay', 'Manatee River Estuary', 'Mcmullen Creek', 'Mill Creek', 'Mud Lake Slough', 'Myakka River', 'Nonsense Creek', 'Palma Sola Bay', 'Piney Point Creek', 'Rattlesnake Slough', 'Sugarhouse Creek', 'Upper Manatee River', 'Ward Lake', or 'Williams Creek'. One to any of the options can be used.
#'
#' @return A \code{data.frame} if similar to \code{fibdata} or \code{mancofibdata} if \code{assf = FALSE} with additional columns describing station categories and optionally filtered by arguments passed to the function.  A \code{sf} object if \code{assf = TRUE} with additional columns for \code{\link{show_fibmap}}.
#'
#' @export
#'
#' @concept anlz
#'
#' @examples
#' # assign categories to all
#' anlz_fibmap(fibdata)
#'
#' # filter by year, month, and area
#' anlz_fibmap(fibdata, yrsel = 2020, mosel = 7, areasel = 'Alafia River')
#'
#' # as sf object
#' anlz_fibmap(fibdata, assf = TRUE)
anlz_fibmap <- function(fibdata, yrsel = NULL, mosel = NULL, areasel = NULL, assf = FALSE){

  levs <- util_fiblevs()

  cols <- c('#2DC938', '#E9C318', '#EE7600', '#CC3231')

  # check if epchc data
  isepchc <- exists("epchc_station", fibdata)

  # check if manco data
  ismanco <- exists("manco_station", fibdata)

  if(isepchc)
    out <- fibdata %>%
      select(area, station = epchc_station, class, yr, mo, Latitude, Longitude, ecoli, entero) %>%
      dplyr::mutate(
        ind = dplyr::case_when(
          class %in% c('1', '3F') ~ 'E. coli',
          class %in% c('2', '3M') ~ 'Enterococcus'
        ),
        cat = dplyr::case_when(
          ind == 'E. coli' ~ cut(ecoli, breaks = levs$ecolilev, right = F, labels = levs$ecolilbs),
          ind == 'Enterococcus' ~ cut(entero, breaks = levs$enterolev, right = F, levs$enterolbs)
        ),
        col = dplyr::case_when(
          ind == 'E. coli' ~ cut(ecoli, breaks = levs$ecolilev, right = F, labels = cols),
          ind == 'Enterococcus' ~ cut(entero, breaks = levs$enterolev, right = F, cols)
        ),
        col = as.character(col)
      )

  if(ismanco)
    out <- fibdata %>%
      dplyr::select(area, station = manco_station, class, yr, mo, Latitude, Longitude, var, val) %>%
      dplyr::filter(var %in% c('ecoli', 'entero')) %>%
      dplyr::select(-uni, -qual, -Sample_Depth_m) %>%
      dplyr::pivot_wider(names_from = 'var', values_from = 'val')
      dplyr::mutate(
        ind = dplyr::case_when(
          class %in% 'Fresh' ~ 'E. coli',
          class %in% 'Estuary' ~ 'Enterococcus'
        ),
        cat = dplyr::case_when(
          ind == 'E. coli' ~ cut(ecoli, breaks = levs$ecolilev, right = F, labels = levs$ecolilbs),
          ind == 'Enterococcus' ~ cut(entero, breaks = levs$enterolev, right = F, levs$enterolbs)
        ),
        col = dplyr::case_when(
          ind == 'E. coli' ~ cut(ecoli, breaks = levs$ecolilev, right = F, labels = cols),
          ind == 'Enterococcus' ~ cut(entero, breaks = levs$enterolev, right = F, cols)
        ),
        col = as.character(col)
      )
  # filter by year
  if(!is.null(yrsel)){
    yrsel <- match.arg(as.character(yrsel), unique(out$yr))
    out <- out %>%
      dplyr::filter(yr %in% yrsel)
  }

  # filter by month
  if(!is.null(mosel)){
    mosel <- match.arg(as.character(mosel), 1:12)
    out <- out %>%
      dplyr::filter(mo %in% mosel)
  }

  # filter by area
  if(!is.null(areasel) & isepchc){
    areasls <- list(
      `Alafia River` = c('Alafia River', 'Alafia River Tributary'),
      `Hillsborough River` = c('Hillsborough River', 'Hillsborough River Tributary',  'Lake Thonotosassa',
                       'Lake Thonotosassa Tributary', 'Lake Roberta'),
      `Big Bend` = 'Big Bend',
      `Cockroach Bay` = c('Cockroach Bay', 'Cockroach Bay Tributary'),
      `East Lake Outfall` = 'East Lake Outfall',
      `Hillsborough Bay` = c('Hillsborough Bay', 'Hillsborough Bay Tributary'),
      `Little Manatee River` = c('Little Manatee River', 'Little Manatee River Tributary'),
      `Lower Tampa Bay` = 'Lower Tampa Bay',
      `McKay Bay` = c('McKay Bay', 'McKay Bay Tributary'),
      `Middle Tampa Bay` = c('Middle Tampa Bay', 'Middle Tampa Bay Tributary'),
      `Old Tampa Bay` = c('Old Tampa Bay', 'Old Tampa Bay Tributary'),
      `Palm River` = c('Palm River', 'Palm River Tributary'),
      `Tampa Bypass Canal` = c('Tampa Bypass Canal', 'Tampa Bypass Canal Tributary'),
      `Valrico Lake` = 'Valrico Lake'
    )
    areasel <- match.arg(areasel, names(areasls), several.ok = TRUE)

    out <- out %>%
      dplyr::filter(area %in% unlist(areasls[areasel]))

  }

  # check empty data
  chk <- length(na.omit(out$cat)) == 0
  if(chk)
    stop('No FIB data for ', paste(lubridate::month(mosel, label = T), yrsel, sep = ' '), ', ', areasel)

  # convert to sf and add more columns to be used by leaflet
  if(assf){

    # create the object to map
    tomap <- out %>%
      dplyr::filter(!is.na(Longitude)) %>%
      dplyr::filter(!is.na(Latitude)) %>%
      dplyr::filter(!is.na(cat)) %>%
      sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326, remove = F) %>%
      dplyr::mutate(
        colnm = factor(col,
                       levels = c('#2DC938', '#E9C318', '#EE7600', '#CC3231'),
                       labels = c('green', 'yellow', 'orange', 'red')
        ),
        indnm = factor(ind,
                       levels = c('E. coli', 'Enterococcus'),
                       labels = c('ecoli', 'entero')
        ),
        conc = dplyr::case_when(
          indnm == 'ecoli' ~ ecoli,
          indnm == 'entero' ~ entero
        ),
        conc = round(conc, 1),
        cls = dplyr::case_when(
          indnm == 'ecoli' ~ 'Freshwater',
          indnm == 'entero' ~ 'Marine'
        )
      ) %>%
      tidyr::unite('grp', indnm, colnm, remove = F)

    # create levels for group, must match order of icons list
    levs <- expand.grid(levels(tomap$colnm), levels(tomap$indnm)) %>%
      unite('levs', Var2, Var1) %>%
      pull(levs)

    # get correct levels
    out <- tomap %>%
      dplyr::mutate(
        grp = factor(grp, levels = levs),
        lab = paste0('<html>Station Number: ', station, '<br>Class: ', cls, ' (<i>', ind, '</i>)<br> Category: ', cat, ' (', conc, '/100mL)</html>')
      ) %>%
      dplyr::select(-colnm, -indnm)

  }

  return(out)

}

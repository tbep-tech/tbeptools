#' Assign threshold categories to Fecal Indicator Bacteria (FIB) data
#'
#' @param fibdata input FIB \code{data.frame} as returned by \code{\link{read_importfib}}
#' @param yrsel optional numeric value to filter output by years in \code{fibdata}
#' @param mosel optional numeric value to filter output by month in \code{fibdata}
#' @param areasel optional character string to filter output by stations in the \code{area} column of \code{fibdata}, see details
#'
#' @details This function is used to create FIB categories for mapping using \code{\link{show_fibmap}}.  Categories based on relevant thresholds are assigned to each observation.  The categories are specific to E. coli or Enterococcus and are assigned based on the station class as freshwater (\code{class} as 1 or 3F) or marine (\code{class} as 2 or 3M), respectively.  A station is categorized into one of four ranges defined by the thresholds as noted in the \code{cat} column of the output, with corresponding colors appropriate for each range as noted in the \code{col} column of the output.
#'
#' The \code{areasel} argument can indicate valid entries in the \code{area} column of \code{fibdata}.  For example, use either \code{"Alafia River"} or \code{"Hillsborough River"} for the corresponding river basins, where rows in  \code{fibdata} are filtered based on the the selection.  All stations are returned if this argument is set as \code{NULL} (default). The Alafia River basin includes values in the \code{area} column of \code{fibdata} as \code{"Alafia River"} and \code{"Alafia River Tributary"}.  The Hillsborough River basin includes values in the \code{area} column of \code{fibdat} as \code{"Hillsborough River"}, \code{"Hillsborough River Tributary"}, \code{"Lake Thonotosassa"}, \code{"Lake Thonotosassa Tributary"}, and \code{"Lake Roberta"}.  Not all areas may be present based on the selection.  All valid options for \code{areasel} include \code{"Alafia River"}, \code{"Hillsborough River"}, \code{"Big Bend"}, \code{"Cockroach Bay"}, \code{"East Lake Outfall"}, \code{"Hillsborough Bay"}, \code{"Little Manatee"}, \code{"Lower Tampa Bay"}, \code{"McKay Bay"}, \code{"Middle Tampa Bay"}, \code{"Old Tampa Bay"}, \code{"Palm River"}, \code{"Tampa Bypass Canal"}, or \code{"Valrico Lake"}.
#'
#' @return A \code{data.frame} similar to \code{fibdata} with additional columns describing station categories and optionally filtered by arguments passed to the function
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
anlz_fibmap <- function(fibdata, yrsel = NULL, mosel = NULL, areasel = NULL){

  levs <- util_fiblevs()

  cols <- c('#2DC938', '#E9C318', '#EE7600', '#CC3231')

  out <- fibdata %>%
    select(area, epchc_station, class, yr, mo, Latitude, Longitude, ecoli, ecocci) %>%
    dplyr::mutate(
      ind = dplyr::case_when(
        class %in% c('1', '3F') ~ 'E. coli',
        class %in% c('2', '3M') ~ 'Enterococcus'
      ),
      cat = dplyr::case_when(
        ind == 'E. coli' ~ cut(ecoli, breaks = levs$ecolilev, right = F, labels = levs$ecolilbs),
        ind == 'Enterococcus' ~ cut(ecocci, breaks = levs$ecoccilev, right = F, levs$ecoccilbs)
      ),
      col = dplyr::case_when(
        ind == 'E. coli' ~ cut(ecoli, breaks = levs$ecolilev, right = F, labels = cols),
        ind == 'Enterococcus' ~ cut(ecocci, breaks = levs$ecoccilev, right = F, cols)
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
  if(!is.null(areasel)){
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

  return(out)

}

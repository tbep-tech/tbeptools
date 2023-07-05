#' Analyze Fecal Indicator Bacteria categories over time by station
#'
#' Analyze Fecal Indicator Bacteria categories over time by station
#'
#' @param fibdata input data frame as returned by \code{\link{read_importfib}}
#' @param yrrng numeric vector indicating min, max years to include, defaults to range of years in \code{epcdata}
#' @param stas numeric vector of stations to include, default as those relevant for the Hillsborough River Basin Management Action Plan, see details
#'
#' @concept show
#'
#' @return A \code{\link[dplyr]{tibble}} object with FIB summaries by year and station, including columns for the estimated geometric mean of fecal coliform concentrations (\code{gmean}), the proportions of samples exceeding 400 CFU / 100 mL (\code{exced}), the count of samples (\code{cnt}), and a category indicating a letter outcome based on the proportion of exceedences (\code{cat}).
#'
#' @details This function is used to create output for plotting a matrix stoplight graphic for FIB categories by station and year.  Each station and year is categorized based on the proportion of monthly samples where fecal indicator bacteria concentrations exceed 400 CFU / 100 mL (using Fecal Coliform, \code{fcolif} in \code{fibdata}).  The proportions are categorized as A, B, C, D, or E with corresponding colors, where the breakpoints for each category are <10\%, 10-30\%, 30-50\%, 50-75\%, and >75\% (right-closed).  See \code{\link{show_fibmatrix}} for additional details.
#'
#' @export
#'
#' @importFrom dplyr "%>%"
#'
#' @seealso \code{\link{show_fibmatrix}}
#'
#' @examples
#' anlz_fibmatrix(fibdata)
anlz_fibmatrix <- function(fibdata, yrrng = NULL,
                           stas = c(143, 108, 107, 135, 118, 148, 105, 152, 137)){

  geomean <- function(x){prod(x)^(1/length(x))}

  # get year range from data if not provided
  if(is.null(yrrng))
    yrrng <- c(1985, max(fibdata$yr, na.rm = T))

  # check stations
  chk <- stas %in% fibdata$epchc_station
  if(any(!chk))
    stop('Station(s) not found in fibdata: ', paste(stas[!chk], collapse = ', '))

  out <- fibdata %>%
    dplyr::filter(epchc_station %in% stas) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(fcolif)) %>%
    dplyr::summarize(
      gmean = geomean(fcolif),
      exced = sum(fcolif > 400) / length(fcolif),
      cnt = dplyr::n(),
      .by = c('epchc_station', 'yr')
    ) %>%
    dplyr::mutate(
      cat = cut(exced, c(-Inf, 0.1, 0.3, 0.5, 0.75, Inf), c('A', 'B', 'C', 'D', 'E')),
      epchc_station = factor(epchc_station, levels = stas)
    ) %>%
    tidyr::complete(yr = yrrng[1]:yrrng[2], epchc_station)

  return(out)

}

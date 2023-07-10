#' Analyze Fecal Indicator Bacteria categories over time by station
#'
#' Analyze Fecal Indicator Bacteria categories over time by station
#'
#' @param fibdata input data frame as returned by \code{\link{read_importfib}}
#' @param yrrng numeric vector indicating min, max years to include, defaults to range of years in \code{epcdata}
#' @param stas optional numeric vector of stations to include, see details
#' @param lagyr numeric for year lag to calculate categories, see details
#'
#' @concept show
#'
#' @return A \code{\link[dplyr]{tibble}} object with FIB summaries by year and station, including columns for the estimated geometric mean of fecal coliform concentrations (\code{gmean}), the proportions of samples exceeding 400 CFU / 100 mL (\code{exced}), the count of samples (\code{cnt}), and a category indicating a letter outcome based on the proportion of exceedences (\code{cat}).
#'
#' @details This function is used to create output for plotting a matrix stoplight graphic for FIB categories by station and year.  Each station and year combination is categorized based on the likelihood of fecal indicator bacteria concentrations exceeding 400 CFU / 100 mL in a given year (using Fecal Coliform, \code{fcolif} in \code{fibdata}).  The proportions are categorized as A, B, C, D, or E (Microbial Water Quality Assessment or MWQA categories) with corresponding colors, where the breakpoints for each category are <10\%, 10-30\%, 30-50\%, 50-75\%, and >75\% (right-closed).  By default, the results for each year are based on a right-centered window that uses the previous two years and the current year to calculate probabilities using the monthly samples (\code{lagyr = 3}). See \code{\link{show_fibmatrix}} for additional details.
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
                           stas = NULL,
                           lagyr = 3){

  geomean <- function(x){prod(x)^(1/length(x))}

  # get year range from data if not provided
  if(is.null(yrrng))
    yrrng <- c(1985, max(fibdata$yr, na.rm = T))

  # valid stations with sufficient data for lagyr
  stasval <- fibdata %>%
    dplyr::filter(yr >= (yrrng[1] - (lagyr - 1)) & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(fcolif) | fcolif < 0) %>%
    summarise(
      nyrs = length(unique(yr)),
      .by = 'epchc_station'
    ) %>%
    dplyr::filter(nyrs >= lagyr) %>%
    dplyr::pull(epchc_station) %>%
    unique()

  # all valid statsions if stas is NULL
  if(is.null(stas))
    stas <- stasval

  # check stations
  chk <- stas %in% fibdata$epchc_station
  if(any(!chk))
    stop('Station(s) not found in fibdata: ', paste(stas[!chk], collapse = ', '))

  # check stations include enough years
  chk <- !stas %in% stasval
  if(any(chk))
    stop('Stations with insufficient data for lagyr: ', paste(stas[chk], collapse = ', '))

  # get geomean, proportion of sites > 400 cfu / 100mL, and prob of exceedence
  # handles lagged calculations
  dat <- fibdata %>%
    dplyr::filter(epchc_station %in% stas) %>%
    dplyr::filter(yr >= (yrrng[1] - (lagyr - 1)) & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(fcolif) | fcolif < 0) %>%
    summarise(
      gmean = geomean(fcolif),
      sumgt400 = sum(fcolif > 400),
      station_tot = dplyr::n(),
      .by = c('epchc_station', 'yr')
    ) %>%
    dplyr::arrange(epchc_station, yr) %>%
    dplyr::mutate(
      sumgt400 = stats::filter(sumgt400, rep(1, lagyr), sides = 1, method = 'convolution'),
      station_tot = stats::filter(station_tot, rep(1, lagyr), sides = 1, method = 'convolution'),
      .by = 'epchc_station'
    ) %>%
    dplyr::mutate(
      exceed_10_400_prob = pbinom(sumgt400 - 1, station_tot, 0.10, lower.tail = FALSE),
      exceed_30_400_prob = pbinom(sumgt400 - 1, station_tot, 0.30, lower.tail = FALSE),
      exceed_50_400_prob = pbinom(sumgt400 - 1, station_tot, 0.50, lower.tail = FALSE),
      exceed_75_400_prob = pbinom(sumgt400 - 1, station_tot, 0.75, lower.tail = FALSE)
    )

  # Put stations into binomial test groups based on significant exceedances of 400cfu criteria
  dat$MWQA <- NA
  dat$MWQA[dat$exceed_10_400_prob >= 0.10] <- 'A'
  dat$MWQA[dat$exceed_10_400_prob < 0.10 & dat$exceed_30_400_prob >= 0.10] <- 'B'
  dat$MWQA[dat$exceed_30_400_prob < 0.10 & dat$exceed_50_400_prob >= 0.10] <- 'C'
  dat$MWQA[dat$exceed_50_400_prob < 0.10 & dat$exceed_75_400_prob >= 0.10] <- 'D'
  dat$MWQA[dat$exceed_75_400_prob < 0.10] <- 'E'

  out <- dat %>%
    dplyr::select(yr, epchc_station, gmean, cat = MWQA) %>%
    dplyr::mutate(
      epchc_station = factor(epchc_station, levels = stas)
    ) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    tidyr::complete(yr = yrrng[1]:yrrng[2], epchc_station)

  return(out)

}

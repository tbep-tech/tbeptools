#' Analyze Fecal Indicator Bacteria categories over time by station
#'
#' Analyze Fecal Indicator Bacteria categories over time by station
#'
#' @param fibdata input data frame as returned by \code{\link{read_importfib}} or \code{\link{read_importentero}}
#' @param yrrng numeric vector indicating min, max years to include, defaults to range of years in data
#' @param stas optional vector of stations to include, see details
#' @param indic character for choice of fecal indicator. Allowable options are \code{fcolif} (default) for fecal coliform, or \code{ecocci} for Enterococcus. A numeric column in the data frame must have this name.
#' @param threshold optional numeric for threshold against which to calculate exceedances for the indicator bacteria of choice. If not provided, defaults to 400 for \code{fcolif} and 130 for \code{ecocci}.
#' @param lagyr numeric for year lag to calculate categories, see details
#'
#' @concept show
#'
#' @return A \code{\link[dplyr]{tibble}} object with FIB summaries by year and station, including columns for the estimated geometric mean of fecal coliform or Enterococcus concentrations (\code{gmean}), the proportion of samples exceeding 400 CFU / 100 mL (fecal coliform) or 130 CFU / 100 mL (Enterococcus) (\code{exced}), the count of samples (\code{cnt}), and a category indicating a letter outcome based on the proportion of exceedences (\code{cat}).
#'
#' @details This function is used to create output for plotting a matrix stoplight graphic for FIB categories by station and year.  Each station and year combination is categorized based on the likelihood of fecal indicator bacteria concentrations exceeding some threshold in a given year.  For fecal coliform, the default threshold is 400 CFU / 100 mL in a given year (using Fecal Coliform, \code{fcolif} in \code{fibdata}).  For Enterococcus, the default threshold is 130 CFU / 100 mL.  The proportions are categorized as A, B, C, D, or E (Microbial Water Quality Assessment or MWQA categories) with corresponding colors, where the breakpoints for each category are <10\%, 10-30\%, 30-50\%, 50-75\%, and >75\% (right-closed).  By default, the results for each year are based on a right-centered window that uses the previous two years and the current year to calculate probabilities using the monthly samples (\code{lagyr = 3}). See \code{\link{show_fibmatrix}} for additional details.
#'
#' @export
#'
#' @importFrom dplyr "%>%"
#'
#' @seealso \code{\link{show_fibmatrix}}
#'
#' @examples
#' anlz_fibmatrix(fibdata)
#' # same result:
#' anlz_fibmatrix(fibdata, indic = 'fcolif')
#' # use different indicator:
#' anlz_fibmatrix(fibdata, indic = 'ecocci')
#' # use different dataset; does not contain an 'fcolif' column so we must specify indic:
#' anlz_fibmatrix(enterodata, indic = 'ecocci', lagyr = 1)
anlz_fibmatrix <- function(fibdata,
                           yrrng = NULL,
                           stas = NULL,
                           indic = c("fcolif", "ecocci"),
                           threshold = NULL,
                           lagyr = 3){

  geomean <- function(x){prod(x)^(1/length(x))}


  # get year range from data if not provided
  if(is.null(yrrng))
    yrrng <- c(min(fibdata$yr, na.rm = T), max(fibdata$yr, na.rm = T))

  # if dealing with epchc data, make a simple 'station' column
  if(exists("epchc_station", fibdata)){fibdata$station <- fibdata$epchc_station}


  # make a generic column for the indicator
  indic <- match.arg(indic)
  fibdata$indic <- fibdata[[which(names(fibdata) == indic)]]

  # if threshold wasn't assigned, assign one based on the indicator of choice
  if(is.null(threshold)){
    thrsh <- switch(indic,
                    'fcolif' = 400,
                    'ecocci' = 130)
  } else {
    thrsh <- threshold
  }

  # valid stations with sufficient data for lagyr
  stasval <- fibdata %>%
    dplyr::filter(yr >= (yrrng[1] - (lagyr - 1)) & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(indic) | indic < 0) %>%
    dplyr::summarise(
      nyrs = length(unique(yr)),
      .by = 'station'
    ) %>%
    dplyr::filter(nyrs >= lagyr) %>%
    dplyr::pull(station) %>%
    unique()

  # all valid stations if stas is NULL
  if(is.null(stas))
    stas <- stasval

  # check stations
  chk <- stas %in% fibdata$station
  if(any(!chk))
    stop('Station(s) not found in fibdata: ', paste(stas[!chk], collapse = ', '))

  # check stations include enough years
  chk <- !stas %in% stasval
  if(any(chk))
    stop('Stations with insufficient data for lagyr: ', paste(stas[chk], collapse = ', '))

  # get geomean, proportion of sites > 400 cfu / 100mL, and prob of exceedence
  # handles lagged calculations
  dat <- fibdata %>%
    dplyr::filter(station %in% stas) %>%
    dplyr::filter(yr >= (yrrng[1] - (lagyr - 1)) & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(indic) | indic < 0) %>%
    summarise(
      gmean = geomean(indic),
      sumgt = sum(indic > thrsh),
      station_tot = dplyr::n(),
      .by = c('station', 'yr')
    ) %>%
    dplyr::arrange(station, yr) %>%
    dplyr::mutate(
      sumgt = stats::filter(sumgt, rep(1, lagyr), sides = 1, method = 'convolution'),
      station_tot = stats::filter(station_tot, rep(1, lagyr), sides = 1, method = 'convolution'),
      .by = 'station'
    ) %>%
    dplyr::mutate(
      exceed_10_prob = pbinom(sumgt - 1, station_tot, 0.10, lower.tail = FALSE),
      exceed_30_prob = pbinom(sumgt - 1, station_tot, 0.30, lower.tail = FALSE),
      exceed_50_prob = pbinom(sumgt - 1, station_tot, 0.50, lower.tail = FALSE),
      exceed_75_prob = pbinom(sumgt - 1, station_tot, 0.75, lower.tail = FALSE)
    )

  # Put stations into binomial test groups based on significant exceedances of 400cfu criteria
  dat$MWQA <- NA
  dat$MWQA[dat$exceed_10_prob >= 0.10] <- 'A'
  dat$MWQA[dat$exceed_10_prob < 0.10 & dat$exceed_30_prob >= 0.10] <- 'B'
  dat$MWQA[dat$exceed_30_prob < 0.10 & dat$exceed_50_prob >= 0.10] <- 'C'
  dat$MWQA[dat$exceed_50_prob < 0.10 & dat$exceed_75_prob >= 0.10] <- 'D'
  dat$MWQA[dat$exceed_75_prob < 0.10] <- 'E'

  out <- dat %>%
    dplyr::select(yr, station, gmean, cat = MWQA) %>%
    dplyr::mutate(
      station = factor(station, levels = stas)
    ) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    tidyr::complete(yr = yrrng[1]:yrrng[2], station)

  return(out)

}

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
#' @details This function is used to create output for plotting a matrix stoplight graphic for FIB categories by station and year.  Each station and year is categorized based on the proportion of monthly samples where fecal indicator bacteria concentrations exceed 400 CFU / 100 mL (using Fecal Coliform, \code{fcolif} in \code{fibdata}).  The proportions are categorized as A, B, C, D, or E (Microbial Water Quality Assessment or MWQA categories) with corresponding colors, where the breakpoints for each category are <10\%, 10-30\%, 30-50\%, 50-75\%, and >75\% (right-closed).  See \code{\link{show_fibmatrix}} for additional details.
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

  # Set time period at 1980-2011
  dat <- fibdata %>%
    dplyr::filter(epchc_station %in% stas) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(fcolif) | fcolif < 0) %>%
    dplyr::mutate(
      bin1 = dplyr::if_else(fcolif > 0 & fcolif <= 200, 1, 0),
      bin2 = dplyr::if_else(fcolif > 200 & fcolif <= 400, 1, 0),
      bin3 = dplyr::if_else(fcolif > 400 & fcolif <= 800, 1, 0),
      bin4 = dplyr::if_else(fcolif > 800 & fcolif <= 2000, 1, 0),
      bin5 = dplyr::if_else(fcolif > 2000, 1, 0)
    ) %>%
    select(yr, epchc_station, fcolif, bin1, bin2, bin3, bin4, bin5)

  # Calculate summary information by epchc_station and year
  station_binsums <- dat %>%
    summarise(
      gmean = geomean(fcolif),
      sum_bin1 = sum(bin1),
      sum_bin2 = sum(bin2),
      sum_bin3 = sum(bin3),
      sum_bin4 = sum(bin4),
      sum_bin5 = sum(bin5),
      .by = c('epchc_station', 'yr')
    )

  # Calculate ranked scores and check for exceedances
  ranks <- station_binsums %>%
    mutate(
      station_tot = sum_bin1 + sum_bin2 + sum_bin3 + sum_bin4 + sum_bin5,
      proprtn1 = sum_bin1 / station_tot,
      proprtn2 = sum_bin2 / station_tot,
      proprtn3 = sum_bin3 / station_tot,
      proprtn4 = sum_bin4 / station_tot,
      proprtn5 = sum_bin5 / station_tot,
      sum345 = sum_bin3 + sum_bin4 + sum_bin5,
      exceed_10_400_prob = pbinom(sum345 - 1, station_tot, 0.10, lower.tail = FALSE),
      exceed_30_400_prob = pbinom(sum345 - 1, station_tot, 0.30, lower.tail = FALSE),
      exceed_50_400_prob = pbinom(sum345 - 1, station_tot, 0.50, lower.tail = FALSE),
      exceed_75_400_prob = pbinom(sum345 - 1, station_tot, 0.75, lower.tail = FALSE)
    )

  # Put stations into binomial test groups based on significant exceedances of 400cfu criteria
  ranks$MWQA <- NA
  ranks$MWQA[ranks$exceed_10_400_prob >= 0.10] <- 'A'
  ranks$MWQA[ranks$exceed_10_400_prob < 0.10 & ranks$exceed_30_400_prob >= 0.10] <- 'B'
  ranks$MWQA[ranks$exceed_30_400_prob < 0.10 & ranks$exceed_50_400_prob >= 0.10] <- 'C'
  ranks$MWQA[ranks$exceed_50_400_prob < 0.10 & ranks$exceed_75_400_prob >= 0.10] <- 'D'
  ranks$MWQA[ranks$exceed_75_400_prob < 0.10] <- 'E'

  out <- ranks %>%
    dplyr::select(yr, epchc_station, gmean, cat = MWQA) %>%
    dplyr::mutate(
      epchc_station = factor(epchc_station, levels = stas)
    ) %>%
    tidyr::complete(yr = yrrng[1]:yrrng[2], epchc_station)

  return(out)

}

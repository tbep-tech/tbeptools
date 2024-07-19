#' Identify Fecal Indicator Bacteria samples as coming from a 'wet' or 'dry' time period
#'
#' @param fibdata input data frame
#' @param precipdata input data frame as returned by \code{\link{read_importrain}}. columns should be: station, date (yyyy-mm-dd), rain (in inches). The object \code{\link{catchprecip}} has this data from 1995-2023 for select stations.
#' @param temporal_window numeric, number of days precipitation should be summed over (1 = day of sample only; 2 = day of sample + day before; etc.)
#' @param wet_threshold  numeric, inches accumulated through the defined temporal window, above which a sample should be defined as being from a 'wet' time period
#'
#' @return a data frame; the original fibdata data frame with three additional columns. \code{rain_sampleDay} is the total rain (inches) on the day of sampling, \code{rain_total} is the total rain (inches) for the period of time defined by \code{temporal_window}, and \code{wet_sample} is logical, indicating whether the rainfall for that station's catchment exceeded the amount over the time period specified in args.
#'
#' @details This function allows the user to specify a threshold for declaring a sample to be taken after an important amount of rain over an important amount of days, and declaring it to be 'wet'. This is of interest because samples taken after significant precipitation (definitions of this vary, which is why the user can specify desired thresholds) are more likely to exceed relevant bacterial thresholds. Identifying samples as 'wet' or not allows for calculation of further indices for wet and dry subsets of samples.
#'
#' @importFrom dplyr %>%
#'
#' @export
#'
#' @examples
#' entero_wetdry <- anlz_fibwetdry(enterodata, catchprecip)
#' head(entero_wetdry)
anlz_fibwetdry <- function(fibdata,
                           precipdata,
                           temporal_window = 2,
                           wet_threshold = 0.5){

  # in precipdata, calculate precip in the temporal window

  # want all the lags up to [temporal_window - 1]  (e.g. for 2-day temporal window, want rain + lag1(rain); for 3-day window want rain + lag1 + lag2),
  # so build the formula for that. if temporal window = 1, just use "rain" as the formula.

  if(temporal_window > 1){
    lag_formula = ""
    for(i in 2:temporal_window){
      lag_formula <- paste0(lag_formula, "+ lag(rain, ", i-1, ")")
    }
    formula_string = paste("rain", lag_formula)
  } else {
    formula_string = "rain"
  }

  formula_obj = parse(text = formula_string)


  # now calculate
  prcp_calcd <- precipdata %>%
    dplyr::group_by(station) %>%
    dplyr::mutate(rain_total = eval(formula_obj)) %>%
    dplyr::rename(rain_sampleDay = rain) %>%
    dplyr::ungroup()

  # left join, fibdata = left, prcipdata = right; on station and date
  # use threshold to show wet or dry
  out <- dplyr::left_join(fibdata, prcp_calcd,
                   by = c("station", "date")) %>%
    dplyr::mutate(wet_sample = rain_total >= wet_threshold)

  return(out)

}

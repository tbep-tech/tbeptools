#' Analyze time series data split by date within years
#'
#' @param df data frame containing date and value columns
#' @param date_split date to split analysis into annual periods
#' @param date_col name of the date column
#' @param value_col name of the value column
#' @param stats list of functions to apply to values, default: `list(avg = mean)`
#'
#' @return A tibble summarizing data for annual periods "before" and "after" the split date
#'
#' @importFrom dplyr mutate group_by summarise n across
#' @importFrom lubridate yday years
#'
#' @concept analyze
#' @export
#'
#' @examples
#' # Create sample data
#' data <- data.frame(
#'   date = seq.Date(as.Date("2010-01-01"), as.Date("2020-12-31"), by = "month"),
#'   value = rnorm(132, mean = 10, sd = 2))
#'
#' # Basic analysis with default statistics
#' split_date <- as.Date("2015-06-15")
#' anlz_splitdata(data, split_date, "date", "value")
anlz_splitdata <- function(
    df, date_split,
    date_col = "date",
    value_col = "value",
    stats = list(
      avg = mean
      )) {

  # Get reference year and day of year for split
  ref_year <- as.numeric(format(date_split, "%Y"))
  yday_split <- lubridate::yday(date_split)

  # Helper function to determine period based on date
  assign_period <- function(date, ref_year, yday_split) {
    date_yday <- lubridate::yday(date)
    date_year <- as.numeric(format(date, "%Y"))

    if (date_year < ref_year ||
        (date_year == ref_year && date_yday < yday_split)) {
      "before"
    } else {
      "after"
    }
  }

  # Helper function to assign year
  assign_year <- function(date, yday_split) {
    date_yday <- lubridate::yday(date)
    date_year <- as.numeric(format(date, "%Y"))

    if (date_yday < yday_split) {
      date_year
    } else {
      date_year + 1
    }
  }

  # Process data
  out <- df %>%
    # Extract period and year
    dplyr::mutate(
      period = factor(
        sapply(.data[[date_col]], assign_period, ref_year, yday_split),
        levels = c("before", "after"), ordered = T),
      year = sapply(.data[[date_col]], assign_year, yday_split)
    ) %>%
    # Group and summarize
    dplyr::group_by(year, period) %>%
    dplyr::summarise(
      dplyr::across(dplyr::all_of(value_col), stats, .names = "{.fn}"),
      .groups = "drop")

  return(out)

}

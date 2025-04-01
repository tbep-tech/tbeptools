#' Analyze storm data split by date within years
#'
#' @param df_hurricane data frame containing date_beg and scale columns for hurricanes
#' @param date_split date to split analysis into annual periods
#' @param stats list of functions to apply to scale values, default: sum, average and count.
#'             Functions should accept numeric vector input and return single value
#'
#' @return A tibble summarizing hurricanes for annual periods "before" and "after" the split date,
#'         with requested statistics computed for the scale values
#'
#' @importFrom dplyr mutate group_by summarise n across
#' @importFrom tidyr pivot_wider
#' @importFrom lubridate yday years
#'
#' @concept analyze
#' @export
#'
#' @examples
#' # Create sample hurricane data
#' hurricanes <- data.frame(
#'   date_beg = as.Date(c(
#'     "1980-07-31", "1980-09-04", "1980-11-07",
#'     "1981-05-06", "1981-08-07", "1981-11-12")),
#'   scale = c(6, 1, 3, 1, 2, 1))
#'
#' # Basic analysis with default statistics (sum, average and count)
#' split_date <- Sys.Date() - years(1)
#' anlz_splitstorms(hurricanes, split_date)
#'
#' # Analysis with custom statistics
#' anlz_splitstorms(hurricanes, split_date,
#'                      stats = list(
#'                        max = max,
#'                        min = min))
anlz_splitstorms <- function(df_hurricane, date_split,
                             stats = list(sum = sum, avg = mean, n = length)){

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

  out <- df_hurricane |>
    # Extract period and year
    dplyr::mutate(
      period = factor(
        sapply(date_beg, assign_period, ref_year, yday_split),
        levels = c("before", "after"), ordered = T),
      year = sapply(date_beg, assign_year, yday_split)
    ) |>
    # Group and summarize
    dplyr::group_by(year, period) |>
    dplyr::summarise(
      dplyr::across(scale, stats, .names = "{.fn}"),
      .groups = "drop"
    )

  return(out)

}

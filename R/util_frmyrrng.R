#' Format a Vector of Years into a Concise Range
#'
#' Takes a vector of years and formats it into a concise string representation.
#' For consecutive years within the same century, the end year is shortened
#' (e.g., "2010-14"). For years spanning different centuries or non-consecutive
#' years, full years are used (e.g., "1998-2001"). Optional prefix and suffix
#' can be added to the formatted range.
#'
#' @param years Numeric vector of years (integers). Can be a single year or multiple years.
#' @param prefix Character string to prepend to the formatted range. Default is empty string.
#' @param suffix Character string to append to the formatted range. Default is empty string.
#'
#' @return A character string representing the year range in a concise format,
#'   with optional prefix and suffix. Returns an empty character vector if input is NULL or empty.
#'
#' @concept util
#'
#' @export
#'
#' @examples
#' # Basic usage
#' util_frmyrrng(2023)  # Returns "2023"
#' util_frmyrrng(2020:2024)  # Returns "2020-24"
#'
#' # Using prefix and suffix
#' util_frmyrrng(2023, prefix = "FY ")  # Returns "FY 2023"
#' util_frmyrrng(2020:2024, suffix = " AD")  # Returns "2020-24 AD"
#' util_frmyrrng(2020:2024, prefix = "Years ", suffix = " CE")  # Returns "Years 2020-24 CE"
#'
#' # Other examples
#' util_frmyrrng(1998:2001)  # Returns "1998-2001"
#' util_frmyrrng(c(2020, 2022))  # Returns "2020-2022"
#' util_frmyrrng(c(2010, 2011, 2012), prefix = "c. ")  # Returns "c. 2010-12"
#'
#' # Empty input
#' util_frmyrrng(numeric(0))  # Returns character(0)
util_frmyrrng <- function(years, prefix = "", suffix = "") {
  # Handle empty or NULL input
  if (is.null(years) || length(years) == 0) {
    return(character(0))
  }

  # Sort and remove duplicates
  years <- sort(unique(as.integer(years)))

  # Format the year range
  result <- if (length(years) == 1) {
    as.character(years)
  } else if (!all(diff(years) == 1)) {
    # Non-consecutive years, return first and last with full years
    paste0(years[1], "–", years[length(years)])
  } else {
    start_year <- years[1]
    end_year <- years[length(years)]
    start_century <- start_year %/% 100
    end_century <- end_year %/% 100

    if (start_century == end_century) {
      # Same century - use shortened end year
      paste0(start_year, "–", end_year %% 100)
    } else {
      # Different centuries - use full end year
      paste0(start_year, "–", end_year)
    }
  }

  # Add prefix and suffix if the result is not empty
  if (length(result) > 0) {
    result <- paste0(prefix, result, suffix)
  }

  return(result)

}

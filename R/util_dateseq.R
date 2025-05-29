#' Generate a two-column data frame of dates
#'
#' @param start_date character for the starting date in "YYYY-MM-DD" format
#' @param end_date character for the ending date in "YYYY-MM-DD" format
#'
#' @details
#' A sequence of dates is generated from the start to end date that includes monthly breaks, such that the first and last day of each month between the start and end dates is returned.  This function is used within \code{\link{read_importwqwin}} to create separate API requests in approximate monthly breaks.
#'
#' @concept util
#'
#' @returns A data frame with two columns: `start` and `end`, containing dates.
#' @export
#'
#' @examples
#' util_dateseq('2023-01-15', '2023-05-04')
util_dateseq <- function(start_date, end_date) {

  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)

  # Check if start and end dates are in the same month and year
  if (lubridate::year(start_date) == lubridate::year(end_date) &&
      lubridate::month(start_date) == lubridate::month(end_date)) {

    return(data.frame(
      start = start_date,
      end = end_date
    ))
  }

  # Initialize result vector with start date
  result <- start_date

  # Always add last day of the starting month (duplicate if start is already last day)
  last_day_start_month <- lubridate::ceiling_date(start_date, "month") - lubridate::days(1)
  result <- c(result, last_day_start_month)

  # Get the first day of the month after start_date
  current_date <- lubridate::ceiling_date(start_date, "month")

  # Loop through months until we reach the month containing end_date
  while (lubridate::year(current_date) < lubridate::year(end_date) ||
         (lubridate::year(current_date) == lubridate::year(end_date) &&
          lubridate::month(current_date) < lubridate::month(end_date))) {

    # Add first day of current month
    result <- c(result, current_date)

    # Add last day of current month
    last_day <- lubridate::ceiling_date(current_date, "month") - lubridate::days(1)
    result <- c(result, last_day)

    # Move to next month
    current_date <- current_date + months(1)

  }

  # Handle the final month containing end_date
  if (lubridate::year(current_date) == lubridate::year(end_date) &&
      lubridate::month(current_date) == lubridate::month(end_date)) {
    # Always add first day of the final month (duplicate if end is already first day)
    first_day_final_month <- lubridate::floor_date(end_date, "month")
    result <- c(result, first_day_final_month)
  }

  # Add end date
  result <- c(result, end_date)

  # Sort the result (don't remove duplicates - we want them for even count)
  result <- sort(result)

  # Convert to two-column data frame
  out <- data.frame(
    start = result[seq(1, length(result), 2)],
    end = result[seq(2, length(result), 2)]
  )

  return(out)

}


% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anlz_splitdata.R
\name{anlz_splitdata}
\alias{anlz_splitdata}
\title{Analyze time series data split by date within years}
\usage{
anlz_splitdata(
  df,
  date_split,
  date_col = "date",
  value_col = "value",
  stats = list(avg = mean)
)
}
\arguments{
\item{df}{data frame containing date and value columns}

\item{date_split}{date to split analysis into annual periods}

\item{date_col}{name of the date column}

\item{value_col}{name of the value column}

\item{stats}{list of functions to apply to values, default: \code{list(avg = mean)}}
}
\value{
A tibble summarizing data for annual periods "before" and "after" the split date
}
\description{
Analyze time series data split by date within years
}
\examples{
# Create sample data
data <- data.frame(
  date = seq.Date(as.Date("2010-01-01"), as.Date("2020-12-31"), by = "month"),
  value = rnorm(132, mean = 10, sd = 2))

# Basic analysis with default statistics
split_date <- as.Date("2015-06-15")
anlz_splitdata(data, split_date, "date", "value")
}
\concept{analyze}

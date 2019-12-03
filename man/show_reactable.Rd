% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show_reactable.R
\name{show_reactable}
\alias{show_reactable}
\title{Create reactable table from matrix data}
\usage{
show_reactable(totab, colfun, nrows = 10)
}
\arguments{
\item{totab}{A data frame in wide format of summarized results}

\item{colfun}{Function specifying how colors are treated in cell background}

\item{nrows}{numeric specifying number of rows in the table}
}
\value{
A \code{\link[reactable]{reactable}} table
}
\description{
Create reactable table from matrix data
}
\details{
This function is used internally within \code{\link{show_matrix}} and \code{\link{show_chlmatrix}}
}
\examples{
data(targets)
data(epcdata)

library(tidyr)
library(dplyr)

# data
totab <- anlz_avedat(epcdata) \%>\%
  .$ann \%>\%
  filter(var \%in\% 'mean_chla') \%>\%
  left_join(targets, by = 'bay_segment') \%>\%
  select(bay_segment, yr, val, chla_thresh) \%>\%
  mutate(
    bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB')),
     outcome = case_when(
      val < chla_thresh ~ 'green',
      val >= chla_thresh ~ 'red'
    )
  ) \%>\%
  select(bay_segment, yr, outcome) \%>\%
  spread(bay_segment, outcome)

# color function
colfun <- function(x){

  out <- case_when(
    x == 'red' ~ '#FF3333',
    x == 'green' ~ '#33FF3B'
  )

  return(out)

}

show_reactable(totab, colfun)
}
\seealso{
Other visualize: \code{\link{show_boxplot}},
  \code{\link{show_chlmatrix}}, \code{\link{show_matrix}},
  \code{\link{show_sitemap}}, \code{\link{show_thrplot}}
}
\concept{visualize}
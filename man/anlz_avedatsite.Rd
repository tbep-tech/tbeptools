% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anlz_avedatsite.R
\name{anlz_avedatsite}
\alias{anlz_avedatsite}
\title{Estimate annual means by site}
\usage{
anlz_avedatsite(epcdata, partialyr = FALSE)
}
\arguments{
\item{epcdata}{\code{data.frame} formatted from \code{read_importwq}}

\item{partialyr}{logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter}
}
\value{
Mean estimates for chlorophyll and secchi
}
\description{
Estimate annual means by site for chlorophyll and secchi data
}
\examples{
# view average estimates
anlz_avedatsite(epcdata)
}
\concept{analyze}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sealevelstations.R
\docType{data}
\name{sealevelstations}
\alias{sealevelstations}
\title{Sea level stations in Tampa Bay}
\format{
A data frame with 4 rows and 5 columns:
\itemize{
\item \code{station_id} integer station identifier
\item \code{station_name} character station name
\item \code{longitude} double longitude
\item \code{latitude} double latitude
\item \code{date_est} date established
}
}
\usage{
sealevelstations
}
\description{
Stations in Tampa Bay with sea level data through  \href{https://api.tidesandcurrents.noaa.gov/api/prod/}{CO-OPS Data Retrieval API} for use with
\code{\link[=read_importsealevels]{read_importsealevels()}}.
}
\concept{data}
\keyword{datasets}

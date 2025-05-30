% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pascofibdata.R
\docType{data}
\name{pascofibdata}
\alias{pascofibdata}
\title{Pasco County FIB data as of 20250304}
\format{
A data frame with 209 rows and 13 variables:
\describe{
\item{pasco_station}{chr, Station name}
\item{SampleTime}{POSIXct, Date/time of sampling}
\item{class}{chr, Waterbody class (\code{Fresh}, \code{Marine})}
\item{yr}{num, Year of sampling}
\item{mo}{num, Month of sampling}
\item{Latitude}{num, Latitude, WGS84}
\item{Longitude}{num, Latitude, WGS84}
\item{Sample_Depth_m}{num, Depth of sample, meters}
\item{var}{chr, Variable name (\code{ecoli}, \code{entero}}
\item{val}{num, Value of variable}
\item{uni}{num, Units of variable}
\item{qual}{num, Qualifier code}
\item{area}{chr, Location name}
}
}
\usage{
pascofibdata
}
\description{
Pasco County FIB data as of 20250304
}
\details{
This dataset includes FIB data from Pasco County (21FLPASC_WQX) where station class is marine (estuary) and Enterococcus data is present or the station class is freshwater (stream/river, reservoir) and E. coli data is present. The data is formatted from the raw data loaded from \code{\link{read_importwqp}}.
}
\examples{
\dontrun{
pascofibdata <- read_importwqp('21FLPASC_WQX', type = 'fib')

nrow(pascofibdata)
ncol(pascofibdata)

save(pascofibdata, file = 'data/pascofibdata.RData')
}
}
\concept{data}
\keyword{datasets}

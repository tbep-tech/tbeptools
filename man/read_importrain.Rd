% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_importrain.R
\name{read_importrain}
\alias{read_importrain}
\title{Download daily precip data and summarise by station catchment}
\usage{
read_importrain(curyr, catchpixels, mos = 1:12, quiet = T)
}
\arguments{
\item{curyr}{numeric for year}

\item{catchpixels}{data.frame with columns named 'station' and 'pixel'. A data frame has been created for key Enterococcus stations, associating each station with all pixels in that station's catchment layer. This is the tbeptools object 'catchpixels'.}

\item{mos}{numeric vector for months to download}

\item{quiet}{logical for messages}
}
\value{
data.frame with station, date, rain columns as a daily average (inches) for all pixels in a catchment
}
\description{
Download daily precip data and summarise by station catchment
}
\details{
Data from the Southwest Florida Water Management District's (SWFWMD) ftp site: ftp://ftp.swfwmd.state.fl.us/pub/radar_rainfall/Daily_Data/
}
\examples{
\dontrun{
read_importrain(2021, catchpixels, quiet = F)
}
}

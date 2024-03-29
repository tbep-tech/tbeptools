% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anlz_hydroload.R
\name{anlz_hydroload}
\alias{anlz_hydroload}
\title{Estimate hydrological estimates and adjustment factors for bay segments}
\usage{
anlz_hydroload(yrs, noaa_key = NULL, trace = FALSE)
}
\arguments{
\item{yrs}{numeric vector indicating years to return}

\item{noaa_key}{user-supplied NOAA key, see details}

\item{trace}{logical indicating if function progress is printed in the consol}
}
\value{
A data frame with hydrological load estimates by bay segments for the requested years
}
\description{
Estimate hydrological estimates and adjustment factors for bay segments
}
\details{
This function uses rainfall and streamflow data from NOAA and USGS and requires an API key.  See the "Authentication" section under the help file for ncdc in the defunct rnoaa package.  This key can be added to the R environment file and called for later use, see the examples.

These estimates are used in annual compliance assessment reports produced by the Tampa Bay Nitrogen Management Consortium. Load estimates and adjustment factors are based on regression models in https://drive.google.com/file/d/11NT0NQ2WbPO6pVZaD7P7Z6qjcwO1jxHw/view?usp=drivesdk
}
\examples{
\dontrun{
# this function requires an API key
# save it to the R environment file (only once)
# save the key, do only once
cat("NOAA_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n",
   file=file.path(normalizePath("~/"), ".Renviron"),
   append=TRUE)

# retrieve the key after saving, may need to restart R
noaa_key <- Sys.getenv('NOAA_key')

# get estimates for 2021
anlz_hydroload(2021, noaa_key)

}
}
\concept{analyze}

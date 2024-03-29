% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_importphyto.R
\name{read_importphyto}
\alias{read_importphyto}
\title{Load local phytoplankton cell count file}
\usage{
read_importphyto(xlsx, download_latest = FALSE, na = c("", "NULL"))
}
\arguments{
\item{xlsx}{chr string path for local excel file, to overwrite if not current}

\item{download_latest}{logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{xlsx} if available}

\item{na}{chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}}
}
\value{
A \code{data.frame} of formatted water quality data.
}
\description{
Load local phytoplankton cell count file
}
\details{
Phytoplankton cell count data downloaded from https://epcbocc.sharepoint.com/:x:/s/Share/ETAfRQ5drmRHntDd1O8s3FQB180Fumed4nQ99w-OIVDxrA?e=eSmtxD&download=1
}
\examples{
\dontrun{
# file path
xlsx <- '~/Desktop/phyto_data.xlsx'

# load and assign to object
phytodata <- read_importphyto(xlsx, download_latest = T)
}
}
\seealso{
\code{\link{read_importwq}}
}
\concept{read}

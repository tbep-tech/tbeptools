% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show_transectsum.R
\name{show_transectsum}
\alias{show_transectsum}
\title{Plot frequency occurrence for a seagrass transect by time for all species}
\usage{
show_transectsum(
  transectocc,
  site,
  species = c("Halodule", "Syringodium", "Thalassia", "Halophila", "Ruppia", "Caulerpa",
    "Dapis", "Chaetomorpha"),
  yrrng = c(1998, 2024),
  abund = FALSE,
  sppcol = NULL
)
}
\arguments{
\item{transectocc}{data frame returned by \code{\link{anlz_transectocc}}}

\item{site}{chr string indicating site results to plot}

\item{species}{chr string indicating which species to plot}

\item{yrrng}{numeric indicating year ranges to evaluate}

\item{abund}{logical indicating if abundance averages are plotted instead of frequency occurrence}

\item{sppcol}{character vector of alternative colors to use for each species, must have length of six}
}
\value{
A \code{\link[plotly]{plotly}} object
}
\description{
Plot frequency occurrence for a seagrass transect by time for all species
}
\details{
This plot provides a quick visual assessment of how frequency occurrence or abundance for multiple species has changed over time at a selected transect. Drift or attached macroalgae (e.g., Caulerpa, Chaetomorpha) and cyanobacteria (Dapis) estimates may not be accurate prior to 2021.
}
\examples{
\dontrun{
transect <- read_transect()
}
transectocc <- anlz_transectocc(transect)
show_transectsum(transectocc, site = 'S3T10')
}
\concept{show}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show_sedimentave.R
\name{show_sedimentave}
\alias{show_sedimentave}
\title{Plot sediment concentration averages by bay segment}
\usage{
show_sedimentave(
  sedimentdata,
  param,
  yrrng = c(1993, 2023),
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"),
  funding_proj = "TBEP",
  lnsz = 1,
  base_size = 12,
  plotly = FALSE,
  family = NA,
  width = NULL,
  height = NULL
)
}
\arguments{
\item{sedimentdata}{input sediment \code{data.frame} as returned by \code{\link{read_importsediment}}}

\item{param}{chr string for which parameter to plot}

\item{yrrng}{numeric vector indicating min, max years to include, use single year for one year of data}

\item{bay_segment}{chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"}

\item{funding_proj}{chr string for the funding project, one to many of "TBEP" (default), "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal Streams"}

\item{lnsz}{numeric for line size}

\item{base_size}{numeric indicating text scaling size for plot}

\item{plotly}{logical if matrix is created using plotly}

\item{family}{optional chr string indicating font family for text labels}

\item{width}{numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}}

\item{height}{numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}}
}
\value{
A \code{\link[ggplot2]{ggplot}} object or a \code{\link[plotly]{plotly}} object if \code{plotly = TRUE} showing sediment averages and 95\% confidence intervals of the selected parameter concentrations for each bay segment
}
\description{
Plot sediment concentration averages by bay segment
}
\details{
Lines for the Threshold Effect Level (TEL) and Potential Effect Level (PEL) are shown for the parameter, if available. Confidence intervals may not be shown for segments with insufficient data.
}
\examples{
show_sedimentave(sedimentdata, param = 'Arsenic')
}
\concept{show}

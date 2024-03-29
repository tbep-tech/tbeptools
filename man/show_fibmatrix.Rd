% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show_fibmatrix.R
\name{show_fibmatrix}
\alias{show_fibmatrix}
\title{Plot a matrix of Fecal Indicator Bacteria categories over time by station}
\usage{
show_fibmatrix(
  fibdata,
  yrrng = NULL,
  stas = c(143, 108, 107, 135, 118, 148, 105, 152, 137),
  lagyr = 3,
  txtsz = 3,
  asreact = FALSE,
  nrows = 10,
  family = NA,
  plotly = FALSE,
  width = NULL,
  height = NULL
)
}
\arguments{
\item{fibdata}{input data frame as returned by \code{\link{read_importfib}}}

\item{yrrng}{numeric vector indicating min, max years to include, defaults to range of years in \code{epcdata}}

\item{stas}{optional numeric vector of stations to include, see details}

\item{lagyr}{numeric for year lag to calculate categories, see details}

\item{txtsz}{numeric for size of text in the plot, applies only if \code{tab = FALSE}.  Use \code{txtsz = NULL} to suppress.}

\item{asreact}{logical indicating if a \code{\link[reactable]{reactable}} object is returned}

\item{nrows}{if \code{asreact = TRUE}, a numeric specifying number of rows in the table}

\item{family}{optional chr string indicating font family for text labels}

\item{plotly}{logical if matrix is created using plotly}

\item{width}{numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}}

\item{height}{numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}}
}
\value{
A static \code{\link[ggplot2]{ggplot}} object is returned by default. A \code{\link[reactable]{reactable}} table is returned if \code{asreact = TRUE}.  An interactive \code{\link[plotly]{plotly}} object is returned if \code{plotly = TRUE}.
}
\description{
Plot a matrix of Fecal Indicator Bacteria categories over time by station
}
\details{
The matrix color codes years and stations based on the likelihood of fecal indicator bacteria concentrations exceeding 400 CFU / 100 mL (using Fecal Coliform, \code{fcolif} in \code{fibdata}).  The likelihoods are categorized as A, B, C, D, or E (Microbial Water Quality Assessment or MWQA categories) with corresponding colors, where the breakpoints for each category are <10\%, 10-30\%, 30-50\%, 50-75\%, and >75\% (right-closed). By default, the results for each year are based on a right-centered window that uses the previous two years and the current year to calculate probabilities from the monthly samples (\code{lagyr = 3}).  Methods and rationale for this categorization scheme are provided by the Florida Department of Environmental Protection, Figure 8 in the document at \url{http://publicfiles.dep.state.fl.us/DEAR/BMAP/Tampa/MST\%20Report/Fecal\%20BMAP\%20DST\%20Final\%20Report\%20--\%20June\%202008.pdf} and Morrison et al. 2009 in the \href{https://drive.google.com/file/d/1vaoAKkwSLlIS2RzeBeCTjQST1dUmo0rr/view}{BASIS 5 proceedings}.

The default stations are those used in TBEP report #05-13 (\url{https://drive.google.com/file/d/1MZnK3cMzV7LRg6dTbCKX8AOZU0GNurJJ/view}) for the Hillsborough River Basin Management Action Plan (BMAP) subbasins.  These include Blackwater Creek (WBID 1482, EPC stations 143, 108), Baker Creek (WBID 1522C, EPC station 107), Lake Thonotosassa (WBID 1522B, EPC stations 135, 118), Flint Creek (WBID 1522A, EPC station 148), and the Lower Hillsborough River (WBID 1443E, EPC stations 105, 152, 137).  Other stations in \code{fibdata} can be plotted using the \code{stas} argument.
}
\examples{
show_fibmatrix(fibdata)
}
\concept{show}

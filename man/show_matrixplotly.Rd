% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show_matrixplotly.R
\name{show_matrixplotly}
\alias{show_matrixplotly}
\title{Creates a plotly matrix from any matrix function input}
\usage{
show_matrixplotly(
  mat,
  family = NA,
  tooltip = "Result",
  width = NULL,
  height = NULL
)
}
\arguments{
\item{mat}{input matrix as output from \code{\link{show_matrix}}, \code{\link{show_segmatrix}}, \code{\link{show_wqmatrix}}, or \code{\link{show_tbnimatrix}}}

\item{family}{optional chr string indicating font family for text labels}

\item{tooltip}{chr string indicating the column name for tooltip}

\item{width}{numeric for width of the plot in pixels}

\item{height}{numeric for height of the plot in pixels}
}
\value{
A \code{\link[plotly]{plotly}} data object
}
\description{
Creates a plotly matrix from any matrix function input
}
\examples{
mat <- show_wqmatrix(epcdata)
show_matrixplotly(mat)
}
\concept{show}

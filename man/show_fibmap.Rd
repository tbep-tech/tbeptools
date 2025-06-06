% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show_fibmap.R
\name{show_fibmap}
\alias{show_fibmap}
\title{Map Fecal Indicator Bacteria (FIB) results by month, year, and location}
\usage{
show_fibmap(fibdata, yrsel, mosel, areasel = NULL, addsta = FALSE)
}
\arguments{
\item{fibdata}{input FIB \code{data.frame} as returned by \code{\link{read_importfib}} or \code{\link{read_importwqp}}, see details}

\item{yrsel}{optional numeric value to filter output by years in \code{fibdata}}

\item{mosel}{optional numeric value to filter output by month in \code{fibdata}}

\item{areasel}{optional character string to filter output by stations in the \code{area} column of \code{fibdata}, see details}

\item{addsta}{logical to add station labels to the map, default \code{FALSE}}
}
\value{
A \code{leaflet} map for the selected year, month, and area showing stations and FIB concentration category
}
\description{
Map Fecal Indicator Bacteria (FIB) results by month, year, and location
}
\details{
Placing the mouse cursor over an item on the map will reveal additional information about a station. See the help file for \code{\link{anlz_fibmap}} for details on the categories and additional arguments.
}
\examples{
# show selected year, month
show_fibmap(fibdata, yrsel = 2023, mosel = 8)

# show selected year, month, and area
show_fibmap(fibdata, yrsel = 2020, mosel = 7, areasel = 'Alafia River')

# Manatee County data
show_fibmap(mancofibdata, yrsel = 2020, mosel = 7, areasel = 'Little Manatee River')
}
\seealso{
\code{\link{anlz_fibmap}}
}
\concept{show}

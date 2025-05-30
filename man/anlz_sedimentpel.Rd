% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anlz_sedimentpel.R
\name{anlz_sedimentpel}
\alias{anlz_sedimentpel}
\title{Get sediment PEL ratios at stations in Tampa Bay}
\usage{
anlz_sedimentpel(
  sedimentdata,
  yrrng = c(1993, 2023),
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"),
  funding_proj = "TBEP"
)
}
\arguments{
\item{sedimentdata}{input sediment \code{data.frame} as returned by \code{\link{read_importsediment}}}

\item{yrrng}{numeric vector indicating min, max years to include, use single year for one year of data}

\item{bay_segment}{chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"}

\item{funding_proj}{chr string for the funding project, one to many of "TBEP" (default), "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal Streams"}
}
\value{
A \code{data.frame} object with average PEL ratios and grades at each station
}
\description{
Get sediment PEL ratios at stations in Tampa Bay
}
\details{
Average PEL ratios for all contaminants graded from A to F for benthic stations monitored in Tampa Bay are estimated. The PEL is a measure of how likely a contaminant is to have a toxic effect on invertebrates that inhabit the sediment. The PEL ratio is the contaminant concentration divided by the Potential Effects Levels (PEL) that applies to a contaminant, if available. Higher ratios and lower grades indicate sediment conditions that are likely unfavorable for invertebrates. The station average combines the PEL ratios across all contaminants measured at a station and the grade applies to the average.

The grade breaks for the PEL ratio are 0.00756, 0.02052, 0.08567, and 0.28026, with lower grades assigned to the higher breaks.
}
\examples{
anlz_sedimentpel(sedimentdata)
}
\seealso{
\code{\link{show_sedimentpelmap}}
}
\concept{anlz}

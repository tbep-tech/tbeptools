% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anlz_transectave.R
\name{anlz_transectave}
\alias{anlz_transectave}
\title{Get annual averages of seagrass frequency occurrence by bay segments and year}
\usage{
anlz_transectave(
  transectocc,
  bay_segment = c("OTB", "HB", "MTB", "LTB", "BCB"),
  total = TRUE,
  yrrng = c(1998, 2019),
  rev = FALSE
)
}
\arguments{
\item{transectocc}{data frame returned by \code{\link{anlz_transectocc}}}

\item{bay_segment}{chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "BCB"}

\item{total}{logical indicating if average frequency occurrence is calculated for the entire bay across segments}

\item{yrrng}{numeric indicating year ranges to evaluate}

\item{rev}{logical if factor levels for bay segments are reversed}
}
\value{
A data frame of annual averages by bay segment
}
\description{
Get annual averages of seagrass frequency occurrence by bay segments and year
}
\examples{
\dontrun{
transect <- read_transect()
}
transectocc <- anlz_transectocc(transect)
anlz_transectave(transectocc)
}
\seealso{
Other analyze: 
\code{\link{anlz_attain}()},
\code{\link{anlz_avedatsite}()},
\code{\link{anlz_avedat}()},
\code{\link{anlz_iwrraw}()},
\code{\link{anlz_refs}()},
\code{\link{anlz_tbbimed}()},
\code{\link{anlz_tdlcrkindic}()},
\code{\link{anlz_tdlcrk}()},
\code{\link{anlz_transectavespp}()},
\code{\link{anlz_transectocc}()},
\code{\link{anlz_yrattain}()}
}
\concept{analyze}
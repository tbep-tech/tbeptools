#' Get sediment PEL ratios at stations in Tampa Bay
#'
#' Get sediment PEL ratios at stations in Tampa Bay
#'
#' @param sedimentdata input sediment \code{data.frame} as returned by \code{\link{read_importsediment}}
#' @param yrrng numeric vector indicating min, max years to include, use single year for one year of data
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"
#' @param funding_proj chr string for the funding project, one to many of "TBEP" (default), "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal Streams"
#'
#' @return A \code{data.frame} object with average PEL ratios and grades at each station
#'
#' @export
#'
#' @concept anlz
#'
#' @details Average PEL ratios for all contaminants graded from A to F for benthic stations monitored in Tampa Bay are estimated. The PEL is a measure of how likely a contaminant is to have a toxic effect on invertebrates that inhabit the sediment. The PEL ratio is the contaminant concentration divided by the Potential Effects Levels (PEL) that applies to a contaminant, if available. Higher ratios and lower grades indicate sediment conditions that are likely unfavorable for invertebrates. The station average combines the PEL ratios across all contaminants measured at a station and the grade applies to the average.
#'
#' The grade breaks for the PEL ratio are 0.00756, 0.02052, 0.08567, and 0.28026, with lower grades assigned to the higher breaks.
#'
#' @seealso \code{\link{show_sedimentpelmap}}
#'
#' @examples
#' anlz_sedimentpel(sedimentdata)
anlz_sedimentpel <- function(sedimentdata, yrrng = c(1993, 2024), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP'){

  # combine all, take average, get grade
  out <- anlz_sedimentaddtot(sedimentdata, yrrng = yrrng, bay_segment = bay_segment, funding_proj = funding_proj, pelave = TRUE) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude) %>%
    dplyr::summarise(
      PELRatio = mean(PELRatio, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Grade = cut(PELRatio, breaks = c(-Inf, 0.00756, 0.02052, 0.08567, 0.28026, Inf), labels = c('A', 'B', 'C', 'D', 'F'))
    )

  return(out)

}

#' Get sediment PEL ratios at stations in Tampa Bay
#'
#' Get sediment PEL ratios at stations in Tampa Bay
#'
#' @param sedimentdata input sediment \code{data.frame} as returned by \code{\link{read_importsediment}}
#' @param yrrng numeric vector indicating min, max years to include, use single year for one year of data
#'
#' @return A \code{data.frame} object with average PEL ratios and grades at each station
#' @export
#'
#' @concept anlz
#'
#' @details Average PEL ratios graded from A to F for benthic stations monitored in Tampa Bay are estimated. The PEL is a measure of how likely a contaminant is to have a toxic effect on invertebrates that inhabit the sediment. The PEL ratio is the contaminant concentration divided by the Potential Effects Levels (PEL) that applies to a contaminant, if available. Higher ratios and lower grades indicate sediment conditions that are likely unfavorable for invertebrates. The station average combines the PEL ratios across all contaminants measured at a station and the grade applies to the average.
#'
#' The grade breaks for the PEL ratio are 0.00756, 0.02052, 0.08567, and 0.28026, with lower grades assigned to the higher breaks.
#'
#' @seealso \code{\link{show_sedimentpelmap}}
#'
#' @examples
#' anlz_sedimentpel(sedimentdata)
anlz_sedimentpel <- function(sedimentdata, yrrng = c(1993, 2021)){

  # make yrrng two if only one year provided
  if(length(yrrng) == 1)
    yrrng <- rep(yrrng, 2)

  # yrrng must be in ascending order
  if(yrrng[1] > yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1993, 2017)')

  # yrrng not in sedimentdata
  if(any(!yrrng %in% sedimentdata$yr))
    stop(paste('Check yrrng is within', paste(range(sedimentdata$yr, na.rm = TRUE), collapse = '-')))

  # get avg PELRatio and grades
  out <- sedimentdata %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(FundingProject %in% 'TBEP') %>%
    dplyr::filter(Replicate == 'no') %>%
    dplyr::filter(!is.na(PELRatio)) %>%
    # dplyr::filter(SedResultsType %in% c('Organics', 'Metals')) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude) %>%
    dplyr::summarise(
      PELRatio = mean(PELRatio, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::filter(!is.na(PELRatio)) %>%
    dplyr::mutate(
      Grade = cut(PELRatio, breaks = c(-Inf, 0.00756, 0.02052, 0.08567, 0.28026, Inf), labels = c('A', 'B', 'C', 'D', 'F'))
    )

  return(out)

}

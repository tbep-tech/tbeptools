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
anlz_sedimentpel <- function(sedimentdata, yrrng = c(1993, 2021), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP'){

  # make yrrng two if only one year provided
  if(length(yrrng) == 1)
    yrrng <- rep(yrrng, 2)

  # yrrng must be in ascending order
  if(yrrng[1] > yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1993, 2017)')

  # yrrng not in sedimentdata
  if(any(!yrrng %in% sedimentdata$yr))
    stop(paste('Check yrrng is within', paste(range(sedimentdata$yr, na.rm = TRUE), collapse = '-')))

  # check bay segments
  chk <- !bay_segment %in% c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')
  if(any(chk)){
    msg <- bay_segment[chk]
    stop('bay_segment input is incorrect: ', paste(msg, collapse = ', '))
  }

  # check funding project
  chk <- !funding_proj %in% c('TBEP', 'TBEP-Special', 'Apollo Beach', 'Janicki Contract', 'Rivers', 'Tidal Streams')
  if(any(chk)){
    msg <- funding_proj[chk]
    stop('funding_proj input is incorrect: ', paste(msg, collapse = ', '))
  }

  # param lookups
  metalpar <- c('Arsenic', 'Cadmium', 'Chromium', 'Copper', 'Lead', 'Mercury', 'Nickel', 'Silver', 'Zinc')
  lmwpahpar <- c('Acenaphthene', 'Acenaphthylene', 'Anthracene', 'Fluorene', 'Naphthalene', 'Phenanthrene')
  hmwpahpar <- c('Benzo(a)anthracene', 'Benzo(a)pyrene', 'Chrysene', 'Dibenzo(a,h)anthracene', 'Fluoranthene', 'Pyrene')
  ddtpar <- c('DDD', 'DDE', 'DDT')

  # filter relevant data
  flt <- sedimentdata %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(FundingProject %in% funding_proj) %>%
    dplyr::filter(Replicate == 'no') %>%
    dplyr::filter(AreaAbbr %in% bay_segment)

  # metals
  mets <- flt %>%
    dplyr::filter(Parameter %in% metalpar)

  # lmwpah
  lmwpah <- flt %>%
    dplyr::filter(Parameter %in% lmwpahpar)

  # get sum of lmwpah
  lmwpahsum <- lmwpah %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude) %>%
    dplyr::summarize(
      lmwpahsum = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'lmwpah',
      PELRatio = lmwpahsum / 1442
    )

  # hmwpah
  hmwpah <- flt %>%
    dplyr::filter(Parameter %in% hmwpahpar)

  # get sum of hmwpah
  hmwpahsum <- hmwpah %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude) %>%
    dplyr::summarize(
      hmwpahsum = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'hmwpah',
      PELRatio = hmwpahsum / 6676
    )

  # total pah
  pahsum <- flt %>%
    dplyr::filter(Parameter %in% c(lmwpahpar, hmwpahpar)) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude) %>%
    dplyr::summarize(
      pahsum = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'pah',
      PELRatio = pahsum / 16770
    )

  #lindane
  lindanesum <- flt %>%
    dplyr::filter(Parameter %in% 'G BHC')

  # chlordane
  chlordanesum <- flt %>%
    dplyr::filter(Parameter %in% 'Total Chlordane')

  # dieldrin
  dieldrinsum <- flt %>%
    dplyr::filter(Parameter %in% 'Dieldrin')

  # ddt
  ddt <- flt %>%
    dplyr::filter(Parameter %in% ddtpar)

  # get sum of ddt
  ddtsum <- ddt %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude) %>%
    dplyr::summarize(
      ddtsum = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'total ddt',
      PELRatio = ddtsum / 51.7
    )

  # get sum of pcb
  pcbsum <- flt %>%
    dplyr::filter(grepl('^PCB', Parameter)) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude) %>%
    dplyr::summarize(
      pcbsum = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'total pcb',
      PELRatio = pcbsum / 189
    )

  # combine all, take average, get grade
  out <- bind_rows(mets, lmwpah, lmwpahsum, hmwpah, hmwpahsum, pahsum, lindanesum, chlordanesum,
                   dieldrinsum, ddt, ddtsum, pcbsum) %>%
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

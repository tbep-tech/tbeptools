#' Add contaminant totals to sediment data
#'
#' @inheritParams anlz_sedimentpel
#' @param param optional character string of a parameter to filter the results
#' @param pelave logical indicating if output is used for \code{\link{anlz_sedimentpel}}
#'
#' @return A \code{data.frame} object similar to the input, but filtered by the arguments and contaminant totals added. Replicate samples are also removed.
#'
#' @export
#'
#' @details This function adds totals to the \code{sedimentdata} input for total PCBs, total DDT, total LMW PAH, total HMW PAH, and total PAH.  Appropriate TEL/PEL values for the totals are also added.
#'
#' @concept anlz
#'
#' @examples
#' anlz_sedimentaddtot(sedimentdata)
anlz_sedimentaddtot <- function(sedimentdata, yrrng = c(1993, 2022), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP', param = NULL, pelave = TRUE){

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
  chlordanepar <- c('A Chlordane', 'G Chlordane')

  # filter relevant data
  flt <- sedimentdata %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(FundingProject %in% funding_proj) %>%
    dplyr::filter(Replicate == 'no') %>%
    dplyr::filter(AreaAbbr %in% bay_segment) %>%
    dplyr::filter(!Parameter %in% 'Total Chlordane') # these are summed from a and g chlordane below

  # metals
  mets <- flt %>%
    dplyr::filter(Parameter %in% metalpar)

  # lmwpah
  lmwpah <- flt %>%
    dplyr::filter(Parameter %in% lmwpahpar)

  # get sum of lmwpah
  lmwpahsum <- lmwpah %>%
    dplyr::mutate(
      ValueAdjusted = ifelse(grepl('T|U', Qualifier), NA, ValueAdjusted)
    ) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude, SedResultsType, Units) %>%
    dplyr::summarize(
      ValueAdjusted = sum(ValueAdjusted, na.rm = T),
      Units = unique(Units),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'Total LMW PAH',
      TEL = 312,
      PEL = 1442,
      PELRatio = ValueAdjusted / PEL,
    )

  # hmwpah
  hmwpah <- flt %>%
    dplyr::filter(Parameter %in% hmwpahpar)

  # get sum of hmwpah
  hmwpahsum <- hmwpah %>%
    dplyr::mutate(
      ValueAdjusted = ifelse(grepl('T|U', Qualifier), NA, ValueAdjusted)
    ) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude, SedResultsType, Units) %>%
    dplyr::summarize(
      ValueAdjusted = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'Total HMW PAH',
      TEL = 655,
      PEL = 6676,
      PELRatio = ValueAdjusted / PEL
    )

  # total pah
  pahsum <- flt %>%
    dplyr::filter(Parameter %in% c(lmwpahpar, hmwpahpar)) %>%
    dplyr::mutate(
      ValueAdjusted = ifelse(grepl('T|U', Qualifier), NA, ValueAdjusted)
    ) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude, SedResultsType, Units) %>%
    dplyr::summarize(
      ValueAdjusted = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'Total PAH',
      TEL = 1680,
      PEL = 16770,
      PELRatio = ValueAdjusted / PEL
    )

  #lindane
  lindanesum <- flt %>%
    dplyr::filter(Parameter %in% 'G BHC') %>%
    dplyr::mutate(
      ValueAdjusted = ifelse(grepl('T|U', Qualifier), NA, ValueAdjusted)
    )

  # total chlordane
  chlordanesum <- flt %>%
    dplyr::filter(Parameter %in% chlordanepar) %>%
    dplyr::mutate(
      ValueAdjusted = ifelse(grepl('T|U', Qualifier), NA, ValueAdjusted)
    ) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude, SedResultsType, Units) %>%
    dplyr::summarize(
      ValueAdjusted = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'Total Chlordane',
      TEL = 2.26,
      PEL = 4.79,
      PELRatio = ValueAdjusted / PEL
    )

  # dieldrin
  dieldrinsum <- flt %>%
    dplyr::filter(Parameter %in% 'Dieldrin')

  # ddt
  ddt <- flt %>%
    dplyr::filter(Parameter %in% ddtpar)

  # get sum of ddt
  ddtsum <- ddt %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude, SedResultsType, Units) %>%
    dplyr::summarize(
      ValueAdjusted = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'Total DDT',
      TEL = 3.89,
      PEL = 51.7,
      PELRatio = ValueAdjusted / PEL
    )

  # get sum of pcb
  pcbsum <- flt %>%
    dplyr::filter(grepl('^PCB', Parameter)) %>%
    dplyr::mutate(
      ValueAdjusted = ifelse(grepl('T|U', Qualifier), NA, ValueAdjusted)
    ) %>%
    dplyr::group_by(yr, AreaAbbr, StationNumber, Latitude, Longitude, SedResultsType, Units) %>%
    dplyr::summarize(
      ValueAdjusted = sum(ValueAdjusted, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::mutate(
      Parameter = 'Total PCB',
      TEL = 21.6,
      PEL = 189,
      PELRatio = ValueAdjusted / PEL
    )

  if(pelave)
    out <- dplyr::bind_rows(mets, lmwpah, lmwpahsum, hmwpah, hmwpahsum, pahsum, lindanesum, chlordanesum,
                   dieldrinsum, ddt, ddtsum, pcbsum)

  if(!pelave)
    out <- dplyr::bind_rows(lmwpahsum, hmwpahsum, pahsum, ddtsum, pcbsum, chlordanesum) %>%
      dplyr::mutate(
        BetweenTELPEL = ifelse(ValueAdjusted > TEL & ValueAdjusted <= PEL, 'Yes', 'No'),
        ExceedsPEL = ifelse(ValueAdjusted > PEL, 'Yes', 'No')
      ) %>%
      dplyr::bind_rows(flt)

  # filter by parameter if param is not null
  if(!is.null(param)){

    # check if param is in data
    params <- out$Parameter %>%
      unique %>%
      sort
    chk <- !param %in% params
    if(chk)
      stop(param, ' not found in selection')

    out <- out %>%
      dplyr::filter(Parameter %in% !!param)

  }

  return(out)

}

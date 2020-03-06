#' Get site attainments
#'
#' Get site attainment categories for chlorophyll or light attenuation
#'
#' @param avedatsite result returned from \code{\link{anlz_avedatsite}}
#' @param thr chr string indicating with water quality value and appropriate threshold to to plot, one of "chl" for chlorophyll and "la" for light availability
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng optional numeric value for year to return, defaults to all
#'
#' @return a \code{data.frame} for each year and site showing the attainment category
#'
#' @details This function is a simplication of the attainment categories returned by \code{\link{anlz_attain}}.  Sites are only compared to the targets/thresholds that apply separately for chlorophyll or light attenuation.
#'
#' @export
#'
#' @examples
#' avedatsite <- anlz_avedatsite(epcdata)
#' anlz_attainsite(avedatsite)
anlz_attainsite <- function(avedatsite, thr = c('chla', 'la'), trgs = NULL, yrrng = NULL){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # wq to plot
  thr <- match.arg(thr)

  if(is.null(yrrng))
    yrrng <- avedatsite$ann %>%
      dplyr::pull(yr) %>%
      unique %>%
      sort

  # format targets
  trgs <- trgs %>%
    tidyr::gather('var', 'val', -bay_segment, -name) %>%
    tidyr::separate(var, c('var', 'trgtyp'), sep = '_') %>%
    spread(trgtyp, val) %>%
    dplyr::select(bay_segment, var, target, smallex, thresh) %>%
    dplyr::filter(grepl(paste0('^', thr), var))

  # get annual averages, join with targets
  annavesite <- avedatsite$ann %>%
    dplyr::mutate(var = gsub('mean\\_', '', var)) %>%
    dplyr::filter(grepl(paste0('^', thr), var)) %>%
    dplyr::filter(yr %in% yrrng) %>%
    dplyr::left_join(trgs, by = c('bay_segment', 'var'))

  # sanity check
  if(nrow(annavesite) == 0)
    stop(paste(yrrng, "not in epcdata"))

  # is var above/below target
  out <- annavesite %>%
    dplyr::mutate(
      trgtmet = ifelse(val < target, 'yes', 'no')
    )

  return(out)

}

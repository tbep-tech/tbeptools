#' Format phytoplankton data
#'
#' @param datin input \code{data.frame} loaded from \code{\link{read_importphyto}}
#'
#' @return A formatted \code{data.frame} with phytoplankton count data
#' @export
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @details Only seven taxonomic groups are summarized. Pyrodinium bahamense, Karenia brevis, Tripos hircus, Pseudo-nitzschia sp., and Pseudo-nitzschia pungens are retained at the species level. Diatoms are summarized at the class level using Bacillariophyceae, Coscinodiscophyceae, and Mediophyceae and Cyanobacteria are summarized at the phylum level using Cyanobacteriota. All other taxa are grouped into an "other" category.
#'
#' @seealso \code{\link{read_importphyto}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- '~/Desktop/phyto_data.xlsx'
#'
#' # load and assign to object
#' phytodata <- read_importphyto(xlsx, download_latest = TRUE)
#' }
read_formphyto <- function(datin){

  stations <- stations %>%
    dplyr::select(epchc_station, bay_segment) %>%
    dplyr::pull(epchc_station)

  # format
  out <- datin %>%
    dplyr::select(epchc_station = StationNumber, Date = SampleTime, phylum = PHYLUM, class = CLASS, name = NAME, count = COUNT, units = Units) %>%
    dplyr::filter(epchc_station %in% !!stations) %>%
    dplyr::mutate(
      count = as.numeric(count),
      Date = as.Date(Date),
      # qrt = quarter(Date, with_year = TRUE),
      name = dplyr::case_when(
        name %in% c('Pyrodinium bahamense', 'Karenia brevis', 'Tripos hircus', 'Pseudo-nitzschia sp.', 'Pseudo-nitzschia pungens') ~ name,
        class %in% c('Bacillariophyceae', 'Coscinodiscophyceae', 'Mediophyceae') ~ 'Diatoms',
        phylum %in% 'Cyanobacteriota' ~ 'Cyanobacteria',
        T ~ 'other'
      )
    ) %>%
    dplyr::filter(!is.na(name)) %>%
    dplyr::group_by(epchc_station, Date, name, units) %>%
    dplyr::summarise(count = median(count, na.rm = T)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      yrqrt = lubridate::floor_date(Date, unit = 'quarter'),
      yr = lubridate::year(Date),
      mo = lubridate::month(Date, label = T)
    )

  return(out)

}

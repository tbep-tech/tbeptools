#' Get annual averages of seagrass frequency occurrence by bay segments, year, and species
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "BCB"
#' @param yrrng numeric indicating year ranges to evaluate
#' @param species chr string of species to summarize, one to many of "Halodule", "Syringodium", "Thalassia", "Ruppia", "Halophila", "Caulerpa", "Dapis", "Chaetomorpha"
#' @param total logical indicating if total frequency occurrence for all species is also returned
#' @param by_seg logical indicating if separate results by bay segments are retained
#'
#' @return A data frame of annual averages by bay segment
#' @export
#'
#' @details
#' Frequency occurrence estimates are averaged across segments in \code{bay_segment} if \code{by_seg = F}, i.e., separate results by location are not returned.  Results are retained by bay segment if \code{by_seg = T}.  Also note that totals across species (\code{total = T}) are not returned if \code{by_seg = T}.
#'
#' @concept analyze
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#' transectocc <- anlz_transectocc(transect)
#' anlz_transectavespp(transectocc)
anlz_transectavespp <- function(transectocc, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB'), yrrng = c(1998, 2024),
                                species = c('Halodule', 'Syringodium', 'Thalassia', 'Ruppia', 'Halophila', 'Caulerpa', 'Dapis', 'Chaetomorpha'),
                                total = TRUE, by_seg = FALSE){

  # sanity checks
  stopifnot(length(yrrng) == 2)
  stopifnot(yrrng[1] < yrrng[2])

  if(!any(species %in% c('Halodule', 'Syringodium', 'Thalassia', 'Ruppia', 'Halophila', 'Caulerpa', 'Dapis', 'Chaetomorpha')))
    stop('Incorrect species, must be one of Halodule, Syringodium, Thalassia, Ruppia, Halophila, Caulerpa, Dapis, Chaetomorpha')

  if(!any(bay_segment %in% c('OTB', 'HB', 'MTB', 'LTB', 'BCB')))
    stop('Incorrect bay_segment, must be one of OTB, HB, MTB, LTB, BCB')

  sf::st_crs(trnpts) <- 4326

  species <- c('total', species)

  # pts by segment
  trnptsshed <- trnpts %>%
    sf::st_set_geometry(NULL) %>%
    dplyr::select(Transect = TRAN_ID, bay_segment) %>%
    unique

  # fo by species
  filtdat <- transectocc %>%
    dplyr::left_join(trnptsshed, by = 'Transect') %>%
    dplyr::mutate(
      yr = lubridate::year(Date)
    ) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(bay_segment %in% !!bay_segment)

  # aggregate results across segments
  if(!by_seg)
    out <- filtdat %>%
      dplyr::filter(Savspecies %in% !!species) %>%
      dplyr::group_by(yr, Savspecies) %>%
      dplyr::summarise(
        foest = mean(foest, na.rm = T),
        .groups = 'drop'
        ) %>%
      dplyr::mutate(
        Savspecies = factor(Savspecies, levels = species)
      )

  # retain results across segments
  if(by_seg)
    out <- filtdat %>%
      dplyr::filter(Savspecies %in% c('No Cover', !!species)) %>%
      dplyr::group_by(yr, bay_segment, Savspecies) %>%
      dplyr::summarise(
        foest = mean(foest, na.rm = T),
        nsites = sum(nsites, na.rm = T),
        .groups = 'drop'
      ) %>%
      dplyr::mutate(
        Savspecies = factor(Savspecies, levels = c('No Cover', species)),
        bay_segment = factor(bay_segment, levels = !!bay_segment)
      )

  # total
  if(!total)
    out <- out %>%
      dplyr::filter(!Savspecies %in% 'total')

  return(out)

}

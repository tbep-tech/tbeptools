#' Get annual averages of seagrass frequency occurrence by bay segments, year, and species
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "BCB"
#' @param yrrng numeric indicating year ranges to evaluate
#' @param species chr string of species to summarize, one to many of "Halodule", "Syringodium", "Thalassia", "Ruppia", "Halophila spp.", "Caulerpa spp."
#'
#' @return A data frame of annual averages by bay segment
#' @export
#'
#' @details Frequency occurrence estimates are averaged across segments in \cod{bay_segment}, i.e., separate results by location are not returned.
#'
#' @family analyze
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#' transectocc <- anlz_transectocc(transect)
#' anlz_transectavespp(transectocc)
anlz_transectavespp <- function(transectocc, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB'), yrrng = c(1998, 2019),
                                species = c('Halodule', 'Syringodium', 'Thalassia', 'Ruppia', 'Halophila spp.', 'Caulerpa spp.')){

  # sanity checks
  stopifnot(length(yrrng) == 2)
  stopifnot(yrrng[1] < yrrng[2])

  if(!any(species %in% c('Halodule', 'Syringodium', 'Thalassia', 'Ruppia', 'Halophila spp.', 'Caulerpa spp.')))
    stop('Incorrect species, must be one of Halodule, Syringodium, Thalassia, Ruppia, Halophila spp., Caulerpa spp.')

  if(!any(bay_segment %in% c('OTB', 'HB', 'MTB', 'LTB', 'BCB')))
    stop('Incorrect bay_segment, must be one of OTB, HB, MTB, LTB, BCB')

  sf::st_crs(trnpts) <- 4326

  # pts by segment
  trnptsshed <- trnpts %>%
    sf::st_set_geometry(NULL) %>%
    dplyr::select(Transect = TRAN_ID, bay_segment) %>%
    unique

  out <- transectocc %>%
    dplyr::left_join(trnptsshed, by = 'Transect') %>%
    dplyr::mutate(
      yr = lubridate::year(Date)
    ) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::filter(Savspecies %in% !!species) %>%
    dplyr::group_by(yr, Savspecies) %>%
    dplyr::summarise(
      foest = mean(foest, na.rm = T),
      .groups = 'drop'
      ) %>%
    dplyr::mutate(
      Savspecies = factor(Savspecies, levels = species)
    )

  return(out)

}

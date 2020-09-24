#' Get seagrass average abundance and occurrence across transects
#'
#' @param transect data frame returned by \code{\link{read_transect}}
#'
#' @return A data frame with abundance and frequency occurrence estimates aggregated by species, transect, and date.  The nsites column is the total number of placements that were sampled along a transect for a particular date.
#' @export
#'
#' @details Abundance and frequency occurrence are estimated as in Sherwood et al. 2017, equations 1 and 2. In short, frequency occurrence is estimated as the number of instances a species was observed along a transect divided by the number of placements along a transect and average abundance was estimated as the sum of species-specific Braun-Blanquet scores divided by the number of placements along a transect.  All attached and drift algae species are aggregated, except Caulerpa spp. which are grouped separately.
#'
#' @importFrom magrittr %>%
#'
#' @references
#' Sherwood, E.T., Greening, H.S., Johansson, J.O.R., Kaufman, K., Raulerson, G.E. 2017. Tampa Bay (Florida, USA): Documenting seagrass recovery since the 1980's and reviewing the benefits. Southeastern Geographer. 57(3):294-319.
#'
#' @examples
#' #' \dontrun{
#' transect <- read_transect()
#' }
#' anlz_transectocc(transect)
anlz_transectocc <- function(transect){

  out <- transect %>%
    dplyr::filter(var %in% 'Abundance') %>%
    dplyr::mutate(
      Savspecies = dplyr::case_when(
        grepl('Caulerpa', Savspecies) ~ 'Caulerpa spp.',
        grepl('^AA', Savspecies) ~ 'AA',
        grepl('^DA', Savspecies) ~ 'DA',
        T ~ Savspecies
      )
    ) %>%
    dplyr::select(Date, Transect, Site, Savspecies, bb = aveval) %>%
    dplyr::group_by(Date, Transect, Site, Savspecies) %>%
    dplyr::summarise(bb = mean(bb, na.rm = T), .groups = 'drop') %>%
    dplyr::ungroup() %>%
    tidyr::complete(Savspecies, tidyr::nesting(Date, Transect, Site), fill = list(bb = 0)) %>%
    dplyr::group_by(Date, Transect, Savspecies) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      est = purrr::map(data, function(data){

        nsites <- nrow(data)
        foest <- sum(data$bb > 0, na.rm = T) / nsites
        bbest <- sum(data$bb, na.rm = T) / nsites

        out <- tibble::tibble(foest = foest, bbest = bbest, nsites = nsites)

        return(out)

      })
    ) %>%
    dplyr::select(-data) %>%
    tidyr::unnest(est) %>%
    dplyr::ungroup() %>%
    dplyr::filter(Savspecies != 'No Cover')

  return(out)

}


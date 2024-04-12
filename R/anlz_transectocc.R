#' Get seagrass average abundance and occurrence across transects
#'
#' @param transect data frame returned by \code{\link{read_transect}}
#'
#' @return A data frame with abundance and frequency occurrence estimates aggregated by species, transect, and date.  The nsites column is the total number of placements that were sampled along a transect for a particular date.
#' @export
#'
#' @details Abundance and frequency occurrence are estimated as in Sherwood et al. 2017, equations 1 and 2.  In short, frequency occurrence is estimated as the number of instances a species was observed along a transect divided by the number of placements along a transect and average abundance was estimated as the sum of species-specific Braun-Blanquet scores divided by the number of placements along a transect.  The estimates are obtained for all seagrass species including Caulerpa (attached macroalgae) and Dapis (cyanobacteria), whereas all attached and drift algae species are aggregated. Drift or attached macroalgae and cyanobacteria (Dapis) estimates may not be accurate prior to 2021.
#'
#' @concept analyze
#'
#' @importFrom dplyr %>%
#'
#' @references
#' Sherwood, E.T., Greening, H.S., Johansson, J.O.R., Kaufman, K., Raulerson, G.E. 2017. Tampa Bay (Florida, USA): Documenting seagrass recovery since the 1980's and reviewing the benefits. Southeastern Geographer. 57(3):294-319.
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#' anlz_transectocc(transect)
anlz_transectocc <- function(transect){

  # get complete data, fill all species not found with zero
  datcmp <- transect %>%
    dplyr::filter(var %in% 'Abundance') %>%
    dplyr::mutate(
      Savspecies = ifelse(grepl('Caulerpa', Savspecies), 'Caulerpa',
        ifelse(grepl('^AA', Savspecies), 'AA',
          ifelse(grepl('^DA', Savspecies), 'DA',
            ifelse(grepl('Dapis', Savspecies), 'Dapis',
              Savspecies
            )
          )
        )
      )
    ) %>%
    dplyr::select(Date, Transect, Site, Savspecies, bb = aveval) %>%
    dplyr::group_by(Date, Transect, Site, Savspecies) %>%
    dplyr::summarise(bb = mean(bb, na.rm = T), .groups = 'drop') %>%
    dplyr::ungroup() %>%
    tidyr::complete(Savspecies, tidyr::nesting(Date, Transect, Site), fill = list(bb = 0))

  # make no cover a five for bb if nothing else found
  datcmp <- datcmp %>%
    dplyr::group_by(Transect, Date, Site) %>%
    dplyr::mutate(
      bb = ifelse(Savspecies == 'No Cover', 0, bb),
      bb = ifelse(sum(bb[!Savspecies %in% 'No Cover']) == 0 & Savspecies == 'No Cover', 5, bb)
    )

  # # get avg placements across dates by transect
  # plcmnt <- datcmp %>%
  #   dplyr::group_by(Date, Transect) %>%
  #   dplyr::summarize(cnts = length(unique(Site)), .groups = 'drop') %>%
  #   dplyr::group_by(Transect) %>%
  #   dplyr::summarize(plcmnt = mean(cnts, na.rm = T), .groups = 'drop')
  #
  # out <- datcmp %>%
  #   left_join(plcmnt, by = 'Transect') %>%
  #   dplyr::group_by(Date, Transect, Savspecies) %>%
  #   dplyr::summarize(
  #     foest = sum(bb > 0, na.rm = T) / unique(plcmnt),
  #     bbest = sum(bb, na.rm = T) / unique(plcmnt ),
  #     .groups = 'drop'
  #   )

  tots <- datcmp %>%
    dplyr::filter(Savspecies %in% c('Halodule', 'Syringodium', 'Thalassia', 'Ruppia', 'Halophila')) %>%
    dplyr::group_by(Date, Transect, Site) %>%
    dplyr::summarise(bb = mean(bb), .groups = 'drop') %>%
    dplyr::mutate(
      Savspecies = 'total'
    )

  # summarise fo/bb by unique sites per date/transect, this is better than commented code
  out <- datcmp %>%
    dplyr::bind_rows(tots) %>%
    dplyr::group_by(Date, Transect, Savspecies) %>%
    dplyr::summarise(
      nsites = length(unique(Site)),
      foest = sum(bb > 0, na.rm = T) / nsites,
      bbest = sum(bb, na.rm = T) / nsites
    )

  return(out)

}


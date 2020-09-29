#' Get annual averages of seagrass frequency occurrence by bay segments and year
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "BCB"
#' @param logical indicating if average frequency occurrence is calculated for the entire bay across segments
#' @param yrrng numeric indicating year ranges to evaluate
#' @param rev logical if factor levels for bay segments are reversed
#'
#' @return A data frame of annual averages by bay segment
#' @export
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
#' anlz_transectave(transectocc)
anlz_transectave <- function(transectocc, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB'), total = TRUE, yrrng = c(1998, 2019), rev = FALSE){

  # sanity checks
  stopifnot(length(yrrng) == 2)
  stopifnot(yrrng[1] < yrrng[2])

  # bay segment factor levels
  levs <- c('OTB', 'HB', 'MTB', 'LTB', 'BCB')

  sf::st_crs(trnpts) <- 4326

  # pts by segment
  trnptsshed <- trnpts %>%
    sf::st_set_geometry(NULL) %>%
    dplyr::select(Transect = TRAN_ID, bay_segment) %>%
    unique

  # summarize fo by segment, species
  occsum <- transectocc %>%
    dplyr::group_by(Date, Transect) %>%
    dplyr::mutate(foest = foest / sum(foest)) %>%
    dplyr::ungroup() %>%
    dplyr::inner_join(trnptsshed, by = 'Transect') %>%
    dplyr::mutate(yr = lubridate::year(Date)) %>%
    dplyr::group_by(Savspecies, yr, bay_segment) %>%
    dplyr::summarise(
      foest = mean(foest, na.rm = T),
      bbest = mean(bbest, na.rm = T),
      .groups = 'drop'
    ) %>%
    dplyr::filter(yr <= yrrng[2] & yr >= yrrng[1]) %>%
    dplyr::filter(!Savspecies %in% c('No Cover', 'AA', 'DA'))

  # summarize fo total by segment
  segs <- occsum %>%
    dplyr::group_by(yr, bay_segment) %>%
    dplyr::summarise(foest = 100 * sum(foest), .groups = 'drop')

  # add total if true
  if(total){

    tots <- segs %>%
      dplyr::group_by(yr) %>%
      dplyr::summarise(foest = mean(foest, na.rm = T), .groups = 'drop') %>%
      dplyr::mutate(bay_segment = 'Tampa Bay')

    segs <- bind_rows(segs, tots)

    levs <- c('Tampa Bay', levs)
    bay_segment <- c('Tampa Bay', bay_segment)

  }

  if(rev)
    levs <- rev(levs)

  out <- segs %>%
    dplyr::mutate(
      focat = cut(foest, breaks = c(-Inf, 25, 50, 75, Inf), labels = c('red', 'orange', 'yellow', 'green')),
      bay_segment = factor(bay_segment, levels = levs)
    ) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    arrange(yr, bay_segment)

  return(out)

}

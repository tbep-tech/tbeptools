#' Get annual averages of seagrass frequency occurrence by bay segments and year
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "BCB"
#' @param total logical indicating if average frequency occurrence is calculated for the entire bay across segments
#' @param yrrng numeric indicating year ranges to evaluate
#' @param rev logical if factor levels for bay segments are reversed
#'
#' @details
#' The \code{focat} column returned in the results shows a color category based on arbitrary breaks of the frequency occurrence estimates (\code{foest}) at 25, 50, and 75 percent.  These don't necessarily translate to any ecological breakpoints.
#'
#' @return A data frame of annual averages by bay segment
#' @export
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
#' anlz_transectave(transectocc)
anlz_transectave <- function(transectocc, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB'), total = TRUE, yrrng = c(1998, 2023), rev = FALSE){

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

  # fo all
  filtdat <- transectocc %>%
    dplyr::left_join(trnptsshed, by = 'Transect') %>%
    dplyr::mutate(
      yr = lubridate::year(Date)
    ) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::group_by(Date, Transect, bay_segment, yr) %>%
    dplyr::filter(Savspecies %in% 'total') %>%
    dplyr::mutate(foest = 100 * foest)

  # summarize fo total by segment
  segs <- filtdat %>%
    dplyr::group_by(bay_segment, yr) %>%
    dplyr::summarise(foest = mean(foest, na.rm = T))

  # add total if true
  if(total){

    tots <- filtdat %>%
      dplyr::group_by(yr) %>%
      dplyr::summarise(foest = mean(foest, na.rm = T)) %>%
      dplyr::mutate(bay_segment = 'Tampa Bay')

    segs <- bind_rows(segs, tots)

    levs <- c('Tampa Bay', levs)
    bay_segment <- c('Tampa Bay', bay_segment)

  }

  if(rev)
    levs <- rev(levs)

  out <- segs %>%
    dplyr::mutate(
      focat = cut(foest, breaks = c(-Inf, 25, 50, 75, Inf), labels = c('#CC3231', '#EE7600', '#E9C318', '#2DC938')),
      bay_segment = factor(bay_segment, levels = levs)
    ) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::mutate(
      focat = droplevels(focat)
    ) %>%
    arrange(yr, bay_segment)

  return(out)

}

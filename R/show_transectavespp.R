#' Show annual averages of seagrass frequency occurrence by bay segments, year, and species
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "BCB"
#' @param yrrng numeric indicating year ranges to evaluate
#' @param species chr string of species to summarize, one to many of "Halodule", "Syringodium", "Thalassia", "Ruppia", "Halophila spp.", "Caulerpa spp."
#' @param alph numeric indicating alpha value for score category colors
#' @param family optional chr string indicating font family for text labels
#' @param plotly logical if matrix is created using plotly
#'
#' @details Results are based on averages across species by date and transect in each bay segment
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing trends over time by speies for selected bay segments if \code{plotly = FALSE}, otherwise a \code{\link[plotly]{plotly}} object
#' @export
#'
#' @family visualize
#'
#' @importFrom magrittr "%>%"
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#' transectocc <- anlz_transectocc(transect)
#' show_transectavespp(transectocc)
show_transectavespp <- function(transectocc, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB'), yrrng = c(1998, 2019),
                                species = c('Halodule', 'Syringodium', 'Thalassia', 'Ruppia', 'Halophila spp.', 'Caulerpa spp.'),
                                alph = 1, family = NA, plotly = FALSE){

  # annual average by segment
  toplo <- anlz_transectavespp(transectocc, bay_segment = bay_segment, yrrng = yrrng, species = species)

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = yr, y = 100 * foest, fill = Savspecies)) +
    ggplot2::geom_line(alpha = alph) +
    ggplot2::geom_point(pch = 21, size = 3, alpha = alph) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank(),
      text = ggplot2::element_text(family = family)
    ) +
    ggplot2::labs(
      y = '% frequency occurrence',
      title = paste('Seagress estimates for', paste(bay_segment, collapse = ', '))
    )

  if(plotly)
    p <- plotly::ggplotly(p)

  return(p)

}

#' Show annual averages of seagrass frequency occurrence by bay segments, year, and species
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "BCB"
#' @param yrrng numeric indicating year ranges to evaluate
#' @param species chr string of species to summarize, one to many of "Halodule", "Syringodium", "Thalassia", "Ruppia", "Halophila spp.", "Caulerpa spp."
#' @param total logical indicating if total frequency occurrence for all species is also returned
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
#' @references
#' This plot is a representation of Figure 2 in R. Johansson (2016) Seagrass Transect Monitoring in Tampa Bay: A Summary of Findings from 1997 through 2015, Technical report #08-16, Tampa Bay Estuary Program, St. Petersburg, Florida.
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
                                total = TRUE, alph = 1, family = NA, plotly = FALSE){

  # annual average by segment
  toplo <- anlz_transectavespp(transectocc, total = total, bay_segment = bay_segment, yrrng = yrrng, species = species, by_seg = F)

  # sort color palette so its the same regardless of species selected
  sppcol <- c('#FFFFFF', '#ED90A4', '#CCA65A', '#7EBA68', '#00C1B2', '#6FB1E7', '#D494E1')
  names(sppcol) <- c('total', 'Halodule', 'Syringodium', 'Thalassia', 'Ruppia', 'Halophila spp.', 'Caulerpa spp.')
  sppcol <- sppcol[levels(toplo$Savspecies)]

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = yr, y = 100 * foest, fill = Savspecies)) +
    ggplot2::geom_line(alpha = alph) +
    ggplot2::geom_point(pch = 21, size = 3, alpha = alph) +
    ggplot2::scale_fill_manual(values = sppcol) +
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

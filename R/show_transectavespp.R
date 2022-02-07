#' Show annual averages of seagrass frequency occurrence by bay segments, year, and species
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "BCB"
#' @param yrrng numeric indicating year ranges to evaluate
#' @param species chr string of species to summarize, one to many of "Halodule", "Syringodium", "Thalassia", "Ruppia", "Halophila", "Caulerpa"
#' @param total logical indicating if total frequency occurrence for all species is also returned, only applies if \code{asreact = FALSE}
#' @param alph numeric indicating alpha value for score category colors
#' @param family optional chr string indicating font family for text labels
#' @param plotly logical if matrix is created using plotly
#' @param asreact logical if a reactable table is returned instead of a plot
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param sppcol character vector of alternative colors to use for each species, must have length of six
#'
#' @details Results are based on averages across species by date and transect in each bay segment
#'
#' @return If \code{asreact = F}, a \code{\link[ggplot2]{ggplot}} or \code{\link[plotly]{plotly}} (if \code{plotly = T}) object is returned showing trends over time by species for selected bay segments.  If \code{asreact = T}, a \code{\link[reactable]{reactable}} table showing results by year, segment, and species is returned.
#' @export
#'
#' @concept show
#'
#' @references
#' The plot is a representation of figure 2 in Johansson, R. (2016) Seagrass Transect Monitoring in Tampa Bay: A Summary of Findings from 1997 through 2015, Technical report #08-16, Tampa Bay Estuary Program, St. Petersburg, Florida.
#'
#' The table is a representation of table 2, p. 163 in Yarbro, L. A., and P. R. Carlson, Jr., eds. 2016. Seagrass Integrated Mapping and Monitoring Program: Mapping and Monitoring Report No. 2. Fish and Wildlife Research Institute Technical Report TR-17 version 2. vi + 281 p.
#'
#' @importFrom dplyr "%>%"
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#' transectocc <- anlz_transectocc(transect)
#' show_transectavespp(transectocc)
show_transectavespp <- function(transectocc, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB'), yrrng = c(1998, 2021),
                                species = c('Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia', 'Caulerpa'),
                                total = TRUE, alph = 1, family = NA, plotly = FALSE, asreact = FALSE, width = NULL,
                                height = NULL, sppcol = NULL){

  # check correct length of optional color vector
  if(!is.null(sppcol)){
    if(length(sppcol) != 6)
      stop('sppcol required length is six')

    sppcol <- c('#FFFFFF', sppcol)

  }

  # make plot
  if(!asreact){

    # annual average by segment
    toplo <- anlz_transectavespp(transectocc, total = total, bay_segment = bay_segment, yrrng = yrrng, species = species, by_seg = F) %>%
      dplyr::mutate(
        fo = round(100 * foest, 1)
      )

    # sort color palette so its the same regardless of species selected
    if(is.null(sppcol))
      sppcol <- c('#FFFFFF', '#ED90A4', '#CCA65A', '#7EBA68', '#6FB1E7', '#00C1B2', '#D400FF')
    names(sppcol) <- c('total', 'Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia', 'Caulerpa')
    sppcol <- sppcol[levels(toplo$Savspecies)]

    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = yr, y = fo, fill = Savspecies)) +
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
        title = paste('Seagrass estimates for', paste(bay_segment, collapse = ', '))
      )

    if(plotly)
      p <- plotly::ggplotly(p, width = width, height = height) %>%
        config(
          toImageButtonOptions = list(
            format = "svg",
            filename = "myplot"
          )
        )

    out <- p

  }

  # table
  if(asreact){

    # annual average by segment
    totab <- anlz_transectavespp(transectocc, total = total, bay_segment = bay_segment, yrrng = yrrng, species = species, by_seg = T) %>%
      dplyr::mutate(foest = 100 * foest) %>%
      tidyr::spread(Savspecies, foest) %>%
      dplyr::arrange(yr, bay_segment)

    out <- reactable::reactable(totab,
      columns = list(
        yr = reactable::colDef(
          name = 'Year',
          format = reactable::colFormat(digits = 0)
          ),
        bay_segment = reactable::colDef(name = 'Bay segment'),
        nsites = reactable::colDef(
          name = '# of quadrats',
          format = reactable::colFormat(digits = 0)
          )
      ),
      groupBy = 'bay_segment',
      defaultExpanded = T,
      defaultPageSize = nrow(totab),
      defaultColDef = reactable::colDef(
        footerStyle = list(fontWeight = "bold"),
        format = reactable::colFormat(digits = 1, separators = F),
        resizable = TRUE
      ),
      filterable = T
    )

  }

  return(out)

}

#' Create a barplot of seagrass coverage over time in Tampa Bay
#'
#' @param seagrass input \code{data.frame} included with the package as \code{\link{seagrass}}
#' @param maxyr numeric for maximum year to plot
#' @param family optional chr string indicating font family for text labels
#' @param lastlab logical indicating if text label on \code{maxyr} should be included
#' @param axsbrk numeric vector of length two indicating where the x-axis break occurs
#'
#' @details This function creates the flagship seagrass coverage graphic to report on coverage changes over time.  All data were pre-processed and included in the package as the \code{\link{seagrass}} dataset.  Original data are from the Southwest Florida Water Management District and available online at \link[https://data-swfwmd.opendata.arcgis.com/]{https://data-swfwmd.opendata.arcgis.com/}.  This function and the data used to create the plot are distinct from those used for the transect monitoring program.
#'
#' @return A grid object showing acres of total seagrass coverage in Tampa Bay over time.
#'
#' @concept show
#'
#' @export
#'
#' @examples
#' show_seagrasscoverage(seagrass)
show_seagrasscoverage <- function(seagrass, maxyr = 2024, family = 'sans', lastlab = T, axsbrk = c(0.08, 0.1)){

  # check maxyr input
  chk <- !maxyr %in% seagrass$Year
  if(chk)
    stop(maxyr, ' not in seagrass data, must be one of ',  paste(seagrass$Year, collapse = ', '))

  # extra years for padding
  exyrs <- seq(1950, 1953)

  toplo <- tibble::tibble(
      Year = c(exyrs, seq(1982, maxyr))
    ) %>%
    dplyr::left_join(seagrass, by = 'Year', ) %>%
    dplyr::mutate(
      Acres = Acres / 1000,
      ind = 1:nrow(.)
    ) %>%
    dplyr::filter(Year >= 1950 & Year <= maxyr)

  ##
  # base ggplot

  # axis labels
  lbs <- toplo$Year
  brks <- toplo$ind
  brks <- brks[!lbs %in% exyrs[-1]]
  lbs <- lbs[!lbs %in% exyrs[-1]]
  lbs[as.numeric(lbs) %% 2 != 0] <- ''

  p <- ggplot2::ggplot(na.omit(toplo), ggplot2::aes(x = ind, y = Acres)) +
    ggplot2::geom_col(fill = '#00806E', colour = 'black', width = 1.3) +
    ggplot2::geom_segment(x = 0, xend = 2, y = 38, yend = 38, col = 'red', size = 2) +
    ggplot2::geom_segment(x = 4, xend = 42, y = 38, yend = 38, col = 'red', size = 2) +
    ggplot2::geom_segment(x = 42, xend = nrow(toplo) + 1, y = 40, yend = 40, col = 'red', size = 2) +
    ggplot2::annotate("text", label = "Seagrass Coverage Goal", x = 4, y = 40.5, color = 'red', size = 5, hjust = 0, family = family) +
    ggplot2::scale_x_continuous(breaks = brks, labels = lbs, expand = c(0.04, 0.04)) +
    ggplot2::scale_y_continuous(expand = c(0, 0), limits = c(0, 1.1 * max(toplo$Acres, na.rm = T))) +
    ggplot2::theme_grey(base_family = family) +
    ggplot2::theme(
      axis.line = ggplot2::element_line(),
      panel.background = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 12),
      axis.title.x = ggplot2::element_blank(),
      legend.position = 'none',
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank()
    ) +
    labs(
      y = 'Seagrass Coverage (x1,000 acres)'
    )

  # add acreage label to last bar
  if(lastlab){

    # label for last bar
    lastlab <- seagrass %>%
      filter(Year == maxyr) %>%
      pull(Acres) %>%
      round(0) %>%
      format(big.mark = ',') %>%
      paste(., 'acres')

    # y loc for last bar label
    lasty <- seagrass %>%
      filter(Year == maxyr) %>%
      pull(Acres) %>%
      `/`(1000) %>%
      `-`(1)

    p <- p +
      ggplot2::annotate('text', x = nrow(toplo), y = lasty, label = lastlab, angle = 90, hjust = 1, vjust = 0.3, size = 3, family = family)

  }

  ##
  # top, bottom axis line breaks

  gt <- ggplot2::ggplotGrob(p)

  is_axisb <- which(gt$layout$name == "axis-b")
  is_axist <- which(gt$layout$name == "axis-t")
  is_axisl <- which(gt$layout$name == "axis-l")
  is_axisr <- which(gt$layout$name == "axis-r")

  axisb <- gt$grobs[[is_axisb]]
  xline <- axisb$children[[1]]

  # location of break, break type
  xline$y <- grid::unit(rep(1, 4), "npc")
  xline$x <- grid::unit(c(0, axsbrk[1], 1, axsbrk[2]), "npc")
  xline$id <- c(1, 1, 2, 2)
  xline$arrow <- grid::arrow(angle = 90, length = grid::unit(0.07, 'inches'))

  axisb$children[[1]] <- xline
  axist <- xline
  axisl <- gt$grobs[[is_axisl]]

  gt$grobs[[is_axisb]] <- axisb
  gt$grobs[[is_axist]] <- axist
  gt$grobs[[is_axisr]] <- axisl$children[[1]]

  grid::grid.draw(gt)

}

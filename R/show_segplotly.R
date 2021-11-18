#' Plot chlorophyll and secchi data together with matrix outcomes
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param yrrng numeric for year range to plot
#' @param family optional chr string indicating font family for text labels
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#' @param width numeric for width of the plot in pixels
#' @param height numeric for height of the plot in pixels
#'
#' @details This function combines outputs from \code{\link{show_thrplot}} and \code{\link{show_segmatrix}} for a selected bay segment. The plot is interactive and can be zoomed by dragging the mouse pointer over a section of the plot. Information about each cell or value can be seen by hovering over a location in the plot.
#'
#' @return An interactive plotly object
#'
#' @concept show
#'
#' @export
#'
#' @examples
#' show_segplotly(epcdata)
show_segplotly <- function(epcdata, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), yrrng = c(1975, 2019), family = NULL, partialyr = FALSE,
                           width = NULL, height = NULL){

  bay_segment <- match.arg(bay_segment)

  suppressMessages({

    p1 <- show_thrplot(epcdata, bay_segment = bay_segment, thr = "chla", yrrng = yrrng, family = family, txtlab = F, labelexp = F, partialyr = partialyr) +
      ggtitle(NULL) +
      scale_x_continuous(expand = c(0.01, 0.01), breaks = seq(yrrng[1], yrrng[2]))
    p2 <- show_thrplot(epcdata, bay_segment = bay_segment, thr = "la", yrrng = yrrng, family = family, txtlab = F, labelexp = F, partialyr = partialyr) +
      ggtitle(NULL) +
      scale_x_continuous(expand = c(0.01, 0.01), breaks = seq(yrrng[1], yrrng[2]))

    p3 <- show_segmatrix(epcdata, bay_segment = bay_segment, yrrng = yrrng, txtsz = NULL, partialyr = partialyr) +
      scale_y_continuous(expand = c(0,0), breaks = c(yrrng[1]:yrrng[2])) +
      coord_flip() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 7),
        axis.text = element_text(size = 12),
        text = element_text(family = family)
      )

  })

  p3 <- plotly::ggplotly(p3, tooltip = 'Action', width = width, height = height)
  for(i in 1:length(p3$x$data)) p3$x$data[[i]]$showlegend <- FALSE

  p1 <- plotly::ggplotly(p1, width = width, height = height)
  p2 <- plotly::ggplotly(p2, width = width, height = height)
  p2$x$data[[1]]$showlegend <- FALSE
  p2$x$data[[2]]$showlegend <- FALSE
  p2$x$data[[3]]$showlegend <- FALSE
  p2$x$data[[4]]$showlegend <- FALSE

  # remove unnecessary hover text
  p1$x$data[[1]]$text <- gsub('colour:\\sAnnual\\sMean$', '', p1$x$data[[1]]$text)
  p2$x$data[[1]]$text <- gsub('colour:\\sAnnual\\sMean$', '', p2$x$data[[1]]$text)

  out <- plotly::subplot(p1, p3, p2, nrows = 3, heights = c(0.4, 0.2, 0.4), shareX = T, titleY = TRUE)

  return(out)

}

#' Plot a matrix of Fecal Indicator Bacteria categories over time by station or bay segment
#'
#' Plot a matrix of Fecal Indicator Bacteria categories over time by station or bay segment
#'
#' @inheritParams anlz_fibmatrix
#' @param txtsz numeric for size of text in the plot, applies only if \code{tab = FALSE}.  Use \code{txtsz = NULL} to suppress.
#' @param asreact logical indicating if a \code{\link[reactable]{reactable}} object is returned
#' @param nrows if \code{asreact = TRUE}, a numeric specifying number of rows in the table
#' @param family optional chr string indicating font family for text labels
#' @param angle numeric for angle of x-axis text labels
#' @param hjust numeric for horizontal justification of x-axis text labels
#' @param size numeric for size of the x-axis text labels
#' @param plotly logical if matrix is created using plotly
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @concept show
#'
#' @return A static \code{\link[ggplot2]{ggplot}} object is returned by default. A \code{\link[reactable]{reactable}} table is returned if \code{asreact = TRUE}.  An interactive \code{\link[plotly]{plotly}} object is returned if \code{plotly = TRUE}.
#'
#' @details The matrix color codes years and stations based on the likelihood of fecal indicator bacteria concentrations exceeding 400 CFU / 100 mL for Fecal Coliform or 130 CFU / 100 mL for Enterococcus.  Bay segments are used instead of stations if \code{bay_segment} is not \code{NULL} and the input data are from \code{\link{read_importentero}}.  The likelihoods are categorized as A, B, C, D, or E (Microbial Water Quality Assessment or MWQA categories) with corresponding colors, where the breakpoints for each category are <10\%, 10-30\%, 30-50\%, 50-75\%, and >75\% (right-closed). By default, the results for each year are based on a right-centered window that uses the previous two years and the current year to calculate probabilities from the monthly samples (\code{lagyr = 3}).  Methods and rationale for this categorization scheme are provided by the Florida Department of Environmental Protection, Figure 8 in the document at \url{http://publicfiles.dep.state.fl.us/DEAR/BMAP/Tampa/MST\%20Report/Fecal\%20BMAP\%20DST\%20Final\%20Report\%20--\%20June\%202008.pdf} and Morrison et al. 2009 in the \href{https://drive.google.com/file/d/1vaoAKkwSLlIS2RzeBeCTjQST1dUmo0rr/view}{BASIS 5 proceedings}.
#'
#' The default stations for fecal coliform data are those used in TBEP report #05-13 (\url{https://drive.google.com/file/d/1MZnK3cMzV7LRg6dTbCKX8AOZU0GNurJJ/view}) for the Hillsborough River Basin Management Action Plan (BMAP) subbasins if \code{bay_segment} is \code{NULL} and the input data are from \code{\link{read_importfib}}.  These include Blackwater Creek (WBID 1482, EPC stations 143, 108), Baker Creek (WBID 1522C, EPC station 107), Lake Thonotosassa (WBID 1522B, EPC stations 135, 118), Flint Creek (WBID 1522A, EPC station 148), and the Lower Hillsborough River (WBID 1443E, EPC stations 105, 152, 137).  Other stations can be plotted using the \code{stas} argument.
#'
#' @export
#'
#' @importFrom dplyr "%>%"
#' @importFrom reactable colDef
#'
#' @examples
#' show_fibmatrix(fibdata)
#'
#' # change the threshold
#' show_fibmatrix(fibdata, threshold = 200)
#'
#' # change the indicator
#' show_fibmatrix(fibdata, indic = 'entero')
#'
#' # show matrix for only dry samples
#' show_fibmatrix(enterodata, indic = 'entero', lagyr = 1, subset_wetdry = "dry",
#'                temporal_window = 2, wet_threshold = 0.5)
show_fibmatrix <- function(fibdata, yrrng = NULL,
                           stas = NULL, bay_segment = NULL, indic = NULL, threshold = NULL,
                           lagyr = 3, subset_wetdry = c("all", "wet", "dry"), precipdata = NULL,
                           temporal_window = NULL, wet_threshold = NULL,
                           txtsz = 3, asreact = FALSE, nrows = 10, family = NA, angle = 90,
                           size = 10, hjust = 0, plotly = FALSE, width = NULL, height = NULL){

  cols <- c('#2DC938', '#E9C318', '#EE7600', '#CC3231', '#800080')

  toplo <- anlz_fibmatrix(fibdata, yrrng = yrrng, stas = stas, bay_segment = bay_segment,
                          indic = indic, threshold = threshold, lagyr = lagyr,
                          subset_wetdry = subset_wetdry, precipdata = precipdata,
                          temporal_window = temporal_window, wet_threshold = wet_threshold)
  yrrng <- range(toplo$yr)

  # reactable object
  if(asreact){

    totab <- toplo %>%
      dplyr::select(grp, yr, cat) %>%
      tidyr::spread(grp, cat)

    colfun <- function(x){

      out <- dplyr::case_when(
        x %in% 'A' ~ '#2DC938',
        x %in% 'B' ~ '#E9C318',
        x %in% 'C' ~ '#EE7600',
        x %in% 'D' ~ '#CC3231',
        x %in% 'E' ~ '#800080'
      )

      return(out)

    }

    # make reactable
    out <- show_reactable(totab, colfun, nrows = nrows, txtsz = txtsz)

    return(out)

  }

  toplo <- toplo %>%
    dplyr::filter(!is.na(cat))

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = grp, y = yr, fill = cat)) +
    ggplot2::geom_tile(color = 'black') +
    ggplot2::scale_fill_manual(values = cols, na.value = 'white') +
    ggplot2::scale_y_reverse(expand = c(0, 0), limits = c(yrrng[2] + 0.5, yrrng[1] - 0.5),
                             breaks = c(yrrng[1]:yrrng[2])) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      legend.position = 'none',
      panel.grid = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = angle, hjust = hjust, size = size)
    )

  if(!is.null(txtsz))
    p <- p +
      ggplot2::geom_text(data = subset(toplo, !is.na(cat)), ggplot2::aes(label = cat), size = txtsz, family = family)

  if(plotly)
    p <- show_matrixplotly(p, family = family, width = width, height = height)

  return(p)

}



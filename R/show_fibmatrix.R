#' Plot a matrix of Fecal Indicator Bacteria categories over time by station
#'
#' Plot a matrix of Fecal Indicator Bacteria categories over time by station
#'
#' @param fibdata input data frame as returned by \code{\link{read_importfib}}
#' @param txtsz numeric for size of text in the plot, applies only if \code{tab = FALSE}.  Use \code{txtsz = NULL} to suppress.
#' @param yrrng numeric vector indicating min, max years to include, defaults to range of years in \code{epcdata}
#' @param stations numeric vector of stations to include, default as those relevant for the Hillsborough River Basin Management Action Plan
#' @param asreact logical indicating if a \code{\link[reactable]{reactable}} object is returned
#' @param nrows if \code{asreact = TRUE}, a numeric specifying number of rows in the table
#' @param family optional chr string indicating font family for text labels
#' @param plotly logical if matrix is created using plotly
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @concept show
#'
#' @return A static \code{\link[ggplot2]{ggplot}} object is returned by default. A \code{\link[reactable]{reactable}} table is returned if \code{asreact = TRUE}.  An interactive \code{\link[plotly]{plotly}} object is returned if \code{plotly = TRUE}.
#'
#' @details The matrix color codes years by station based on the proportion of monthly samples where fecal indicator bacteria concentration exceed 400 CFU / 100 mL.  The proportions are categorized as A, B, C, D, or E with corresponding colors, where the breakpoints for each category are <10%, 10-30%, 30-50%, 50-75%, and >75% (right-closed). Methods and rationale for this categorization scheme are provided by the Florida Department of Environmental Protection, Figure 8 in the document at \url{http://publicfiles.dep.state.fl.us/DEAR/BMAP/Tampa/MST%20Report/Fecal%20BMAP%20DST%20Final%20Report%20--%20June%202008.pdf}.
#'
#' @export
#'
#' @importFrom dplyr "%>%"
#' @importFrom reactable colDef
#'
#' @examples
#' show_fibmatrix(fibdata)
show_fibmatrix <- function(fibdata, txtsz = 3, yrrng = NULL,
                           stations = c(143, 108, 107, 135, 118, 148, 105, 152, 137), asreact = FALSE,
                           nrows = 10, family = NA, plotly = FALSE, width = NULL,
                           height = NULL){

  geomean <- function(x){prod(x)^(1/length(x))}

  # get year range from data if not provided
  if(is.null(yrrng))
    yrrng <- c(1985, max(fibdata$yr, na.rm = T))

  cols <- c('#2DC938', '#E9C318', '#EE7600', '#CC3231', '#800080')

  toplo <- fibdata %>%
    dplyr::filter(epchc_station %in% stations) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(fcolif)) %>%
    dplyr::summarize(
      gmean = geomean(fcolif),
      exced = sum(fcolif > 400) / length(fcolif),
      cnt = dplyr::n(),
      .by = c('epchc_station', 'yr')
    ) %>%
    dplyr::mutate(
      cat = cut(exced, c(-Inf, 0.1, 0.3, 0.5, 0.75, Inf), c('A', 'B', 'C', 'D', 'E')),
      epchc_station = factor(epchc_station, levels = stations)
    ) %>%
    tidyr::complete(yr = yrrng[1]:yrrng[2], epchc_station)

  # reactable object
  if(asreact){

    totab <- toplo %>%
      dplyr::select(epchc_station, yr, cat) %>%
      tidyr::spread(epchc_station, cat)

    colfun <- function(x){

      out <- dplyr::case_when(
        x %in% 'A' ~ '#2DC938',
        x %in% 'B' ~ '#E9C318',
        x %in% 'C' ~ '#EE7600',
        x %in% 'D' ~ '#CC3231',
        x %in% 'F' ~ '#800080'
      )

      return(out)

    }

    # make reactable
    out <- show_reactable(totab, colfun, nrows = nrows)

    return(out)

  }

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = epchc_station, y = yr, fill = cat)) +
    ggplot2::geom_tile(color = 'black') +
    ggplot2::scale_fill_manual(values = cols, na.value = 'lightgrey') +
    ggplot2::scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      legend.position = 'none',
      panel.grid = ggplot2::element_blank()
    )

  if(!is.null(txtsz))
    p <- p +
      ggplot2::geom_text(data = subset(toplo, !is.na(cat)), ggplot2::aes(label = cat), size = txtsz, family = family)

  if(plotly)
    p <- show_matrixplotly(p, family = family, width = width, height = height)

  return(p)

}



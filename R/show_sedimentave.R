#' Plot sediment concentration averages by bay segment
#'
#' Plot sediment concentration averages by bay segment
#'
#' @inheritParams anlz_sedimentave
#' @param lnsz numeric for line size
#' @param base_size numeric indicating text scaling size for plot
#' @param plotly logical if matrix is created using plotly
#' @param family optional chr string indicating font family for text labels
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object or a \code{\link[plotly]{plotly}} object if \code{plotly = TRUE} showing sediment averages and 95% confidence intervals of the selected parameter concentrations for each bay segment
#'
#' @details Lines for the Threshold Effect Level (TEL) and Potential Effect Level (PEL) are shown for the parameter, if available. Confidence intervals may not be shown for segments with insufficient data.
#'
#' @export
#'
#' @concept show
#'
#' @examples
#' show_sedimentave(sedimentdata, param = 'Arsenic')
show_sedimentave <- function(sedimentdata, param, yrrng = c(1993, 2021), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP', lnsz = 1, base_size = 12, plotly = FALSE, family = NA, width = NULL, height = NULL){

  toplo <- anlz_sedimentave(sedimentdata, param = param, yrrng = yrrng, bay_segment = bay_segment, funding_proj = funding_proj)

  thm <- ggplot2::theme_bw(base_size = base_size) +
    ggplot2::theme(
      panel.border = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank(),
      legend.position = 'top',
      text = ggplot2::element_text(family = family)
    )

  grdtxt <- toplo %>%
    select(grandave, Units) %>%
    unique() %>%
    mutate(grandave = paste('Grand mean:', round(grandave, 3))) %>%
    paste(collapse = ' ')

  ylb <- paste0(param, ' (', unique(toplo$Units), ')')
  ltyp <- 'dashed'
  names(ltyp) <- grdtxt
  ctyp <- 'grey'
  names(ctyp) <- grdtxt

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = AreaAbbr, y = ave)) +
    ggplot2::geom_point(size = 3) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = lov, ymax = hiv), width = 0, na.rm = T) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = grandave, color = grdtxt, linetype = grdtxt), size = lnsz)

  # add pel, tel if present
  chkpel <- unique(toplo$PEL)
  chktel <- unique(toplo$TEL)
  if(!is.na(chkpel) | !is.na(chktel)){

    teltxt <- toplo %>%
      select(TEL, Units) %>%
      unique() %>%
      mutate(TEL = paste('TEL:', TEL)) %>%
      paste(collapse = ' ')
    peltxt <- toplo %>%
      select(PEL, Units) %>%
      unique() %>%
      mutate(PEL = paste('PEL:', PEL)) %>%
      paste(collapse = ' ')

    ylb <- paste0(param, ' (', unique(toplo$Units), ')')
    ltyp <- c('solid', 'solid', ltyp)
    names(ltyp) <- c(peltxt, teltxt, grdtxt)
    ctyp <- c('red', 'pink', ctyp)
    names(ctyp) <-  c(peltxt, teltxt, grdtxt)

    p <- p +
      ggplot2::geom_hline(ggplot2::aes(yintercept = TEL, color = teltxt, linetype = teltxt), size = lnsz) +
      ggplot2::geom_hline(ggplot2::aes(yintercept = PEL, color = peltxt, linetype = peltxt), size = lnsz)

  }

  p <- p +
    ggplot2::scale_linetype_manual(values = ltyp, breaks = names(ctyp)) +
    ggplot2::scale_color_manual(values = ctyp, breaks = names(ctyp)) +
    ggplot2::scale_y_log10(expand = c(0, 0)) +
    ggplot2::scale_x_discrete(drop = F) +
    ggplot2::labs(
      x = 'Bay segment',
      color = NULL,
      linetype = NULL,
      y = ylb
    ) +
    thm

  if(plotly)
    p <- plotly::ggplotly(p, width = width, height = height) %>%
      plotly::layout(
        legend = list(
          traceorder = 'reversed',
          orientation = "h",
          xanchor = "center",
          x = 0.5,
          y = 1.1
        )
      ) %>%
      plotly::config(
        toImageButtonOptions = list(
          format = "svg",
          filename = "myplot"
        )
      )

  return(p)

}

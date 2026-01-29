#' Plot metal concentrations against aluminum
#'
#' Plot metal concentrations against aluminum
#'
#' @param sedimentdata input sediment \code{data.frame} as returned by \code{\link{read_importsediment}}
#' @param param chr string for which parameter to plot, must be a metal
#' @param yrrng numeric vector indicating min, max years to include, use single year for one year of data
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"
#' @param funding_proj chr string for the funding project, one to many of "TBEP" (default), "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal Streams"
#' @param lnsz numeric for line size
#' @param base_size numeric indicating text scaling size for plot
#' @param plotly logical if matrix is created using plotly
#' @param family optional chr string indicating font family for text labels
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object or a \code{\link[plotly]{plotly}} object if \code{plotly = TRUE} showing the ratio of the selected parameter plotted against aluminum concentrations collected at the same site. Black lines show the linear fit of a log-log model and the 95% prediction intervals.
#'
#' @details The plot shows the selected contaminant concentration relative to aluminum, the latter being present as a common metal in the Earth's crust.  An elevated ratio of a metal parameter relative to aluminum suggests it is higher than background concentrations.
#'
#' Lines for the Threshold Effect Level (TEL) and Potential Effect Level (PEL) are shown for the parameter, if available.
#'
#' @references
#'
#' Schropp, S. J., Graham Lewis, F., Windom, H. L., Ryan, J. D., Calder, F. D., & Burney, L. C. 1990. Interpretation of metal concentrations in estuarine sediments of Florida using aluminum as a reference element. Estuaries. 13:227-235.
#'
#' @export
#'
#' @examples
#' show_sedimentalratio(sedimentdata, param = 'Arsenic')
show_sedimentalratio <- function(sedimentdata, param, yrrng = c(1993, 2024), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP', lnsz = 1, base_size = 12, plotly = FALSE, family = 'sans', width = NULL, height = NULL){

  # check paramater is an available metal
  metals <- sedimentdata %>%
    dplyr::filter(SedResultsType == 'Metals') %>%
    dplyr::pull(Parameter) %>%
    unique() %>%
    sort()
  metals <- metals[!metals %in% 'Aluminum']
  chk <- param %in% metals
  if(!chk)
    stop('Selected parameter must be one of ', paste(metals, collapse = ', '))

  # make yrrng two if only one year provided
  if(length(yrrng) == 1)
    yrrng <- rep(yrrng, 2)

  # yrrng must be in ascending order
  if(yrrng[1] > yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1993, 2017)')

  # yrrng not in sedimentdata
  if(any(!yrrng %in% sedimentdata$yr))
    stop(paste('Check yrrng is within', paste(range(sedimentdata$yr, na.rm = TRUE), collapse = '-')))

  # check bay segments
  chk <- !bay_segment %in% c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')
  if(any(chk)){
    msg <- bay_segment[chk]
    stop('bay_segment input is incorrect: ', paste(msg, collapse = ', '))
  }

  # check funding project
  chk <- !funding_proj %in% c('TBEP', 'TBEP-Special', 'Apollo Beach', 'Janicki Contract', 'Rivers', 'Tidal Streams')
  if(any(chk)){
    msg <- funding_proj[chk]
    stop('funding_proj input is incorrect: ', paste(msg, collapse = ', '))
  }

  levs <- c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')
  cols <- c("#F8766D", "#C49A00", "#53B400", "#00C094", "#00B6EB", "#A58AFF",
            "#FB61D7")
  names(cols) <- levs
  shps <- c(16, 17, 15, 3, 5, 7, 8)
  names(shps) <- levs

  flt <- sedimentdata %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(FundingProject %in% funding_proj) %>%
    dplyr::filter(Replicate == 'no') %>%
    dplyr::filter(AreaAbbr %in% bay_segment) %>%
    dplyr::filter(Parameter %in% c(param, 'Aluminum'))

  paramuni <- flt %>%
    dplyr::filter(Parameter %in% !!param) %>%
    pull(Units) %>%
    unique
  alumuni <- flt %>%
    dplyr::filter(Parameter %in% 'Aluminum') %>%
    pull(Units) %>%
    unique
  ylb <- paste0(param, ' (', paramuni, ')')
  xlb <- paste0('Aluminum (', paramuni, ')')

  toplo <- flt %>%
    dplyr::select(StationID, StationNumber, AreaAbbr, Parameter, ValueAdjusted) %>%
    dplyr::summarise(
      ValueAdjusted = mean(ValueAdjusted, na.rm = T),
      .by = c('StationID', 'StationNumber', 'AreaAbbr', 'Parameter')
    ) %>%
    tidyr::pivot_wider(names_from = 'Parameter', values_from = 'ValueAdjusted') %>%
    dplyr::rename(param = !!param) %>%
    dplyr::mutate(
      AreaAbbr = factor(AreaAbbr, levels = levs)
    ) %>%
    dplyr::filter(!is.na(param)) %>%
    dplyr::filter(!is.na(Aluminum))

  tomod <- toplo %>%
    dplyr::filter(!is.infinite(log10(param)) | !is.infinite(log10(Aluminum)))
  lns <- suppressWarnings({
      lm(log10(param) ~ log10(Aluminum), tomod) %>%
        predict(interval = 'prediction', type = 'response') %>%
        data.frame() %>%
        mutate_all(function(x) 10^x) %>%
        bind_cols(tomod)
    })

  thm <- ggplot2::theme_bw(base_size = base_size) +
    ggplot2::theme(
      panel.border = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      text = ggplot2::element_text(family = family)
    )

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = Aluminum, y = param)) +
    ggplot2::geom_point(ggplot2::aes(color = AreaAbbr, shape = AreaAbbr)) +
    ggplot2::scale_y_log10() +
    ggplot2::scale_x_log10() +
    ggplot2::scale_shape_manual(values = shps) +
    ggplot2::scale_color_manual(values = cols) +
    ggplot2::geom_line(data = lns, ggplot2::aes(y = fit), col = 'black', linewidth = lnsz) +
    ggplot2::geom_line(data = lns, ggplot2::aes(y = upr), col = 'black') +
    ggplot2::geom_line(data = lns, ggplot2::aes(y = lwr), col = 'black') +
    thm +
    ggplot2::labs(
      y = ylb,
      x = xlb,
      shape = 'Bay segment',
      color = 'Bay segment'
    )

  # add pel, tel if present
  noalum <- flt %>%
    dplyr::filter(!Parameter %in% 'Aluminum')
  chkpel <- unique(noalum$PEL)
  chktel <- unique(noalum$TEL)
  if(!is.na(chkpel) | !is.na(chktel)){

    teltxt <- noalum %>%
      select(TEL, Units) %>%
      unique() %>%
      mutate(TEL = paste('TEL:', TEL)) %>%
      paste(collapse = ' ')
    peltxt <- noalum %>%
      select(PEL, Units) %>%
      unique() %>%
      mutate(PEL = paste('PEL:', PEL)) %>%
      paste(collapse = ' ')

    ltyp <- c('solid', 'solid')
    names(ltyp) <- c(peltxt, teltxt)

    p <- p +
      ggplot2::geom_hline(data = noalum, ggplot2::aes(yintercept = TEL, linetype = teltxt), linewidth = lnsz, color = 'pink') +
      ggplot2::geom_hline(data = noalum, ggplot2::aes(yintercept = PEL, linetype = peltxt), linewidth = lnsz, color = 'red') +
      ggplot2::scale_linetype_manual(values = ltyp) +
      ggplot2::guides(linetype = guide_legend(override.aes = list(colour = c('red', 'pink')))) +
      labs(
        linetype = NULL
      )

  }

  # plotly
  if(plotly){

    p <- plotly::ggplotly(p, width = width, height = height) %>%
      plotly::config(
        toImageButtonOptions = list(
          format = "svg",
          filename = "myplot"
        )
      )

    # remove extra text from legend
    for(i in 1:length(p$x$data)){
      p$x$data[[i]]$name <- gsub('^\\(|,1,NA\\)$|,1\\)$', '', p$x$data[[i]]$name)
    }

  }

  return(p)

}

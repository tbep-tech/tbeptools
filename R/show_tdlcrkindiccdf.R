#' Plotly empirical CDF plots of tidal creek context indicators
#'
#' Plotly empirical CDF plots of tidal creek context indicators
#'
#' @param id numeric indicating the \code{id} number of the tidal creek to plot
#' @param cntdat output from \code{\link{anlz_tdlcrkindic}}
#' @param yr numeric indicating reference year
#' @param thrsel logical if threshold lines and annotations are shown on the plots
#' @param pal vector of colors for the palette
#'
#' @importFrom plotly add_trace layout plot_ly subplot
#'
#' @concept show
#'
#' @details This function returns several empirical cumulative distribution plots for the tidal creek context indicators.  Points on the plot indicate the observed values and percentiles for the creek specified by \code{id}. The percentiles and CDF values are defined by the "population" of creeks in \code{cntdat}.  Points in the plots are color-coded by sample year to evaluate temporal trends, if any.
#'
#' @return A plotly object
#' @export
#'
#' @examples
#' cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2021)
#' show_tdlcrkindiccdf(495, cntdat, thrsel = TRUE)
show_tdlcrkindiccdf <- function(id, cntdat, yr = 2021, thrsel = FALSE, pal = c('#5C4A42', '#427355', '#004F7E')){

  # variables to plot
  labs <- c('Chla (ug/L)', 'TN (mg/L)', 'Chla:TN', 'DO (mg/L)', 'Florida TSI', 'Nitrate ratio')
  names(labs) <- c('CHLAC', 'TN', 'chla_tn_ratio', 'DO', 'tsi', 'no23_ratio')

  # data to plot
  seldat <- cntdat %>%
    dplyr::filter(id %in% !!id) %>%
    dplyr::mutate(year = factor(year, levels = seq(yr - 10, yr - 1))) %>%
    tidyr::complete(id, wbid, JEI, class, year)

  if(nrow(seldat) == 0)
    return()

  plos <- seldat %>%
    tidyr::gather('var', 'val', -id, -wbid, -JEI, -class, -year) %>%
    dplyr::filter(var %in% names(labs)) %>%
    dplyr::group_by(id, wbid, JEI, class, var) %>%
    tidyr::nest() %>%
    dplyr::ungroup() %>%
    dplyr::mutate(var = factor(var, levels = names(labs))) %>%
    dplyr::arrange(var) %>%
    dplyr::mutate(
      cntdat = list(cntdat),
      plo = purrr::pmap(list(data, var, cntdat), function(data, var, cntdat){

        var <- as.character(var)

        pal_yrs <- leaflet::colorFactor(
          palette = pal,
          na.color = 'yellow',
          levels = as.character(seq(yr - 10, yr - 1))
        )

        ecdfdat <- cntdat[, var]

        ecdffun <- ecdf(ecdfdat)
        plodat <- tibble(
          val = seq(min(ecdfdat, na.rm = TRUE), max(ecdfdat, na.rm = TRUE), length.out = 200),
          y = ecdffun(val)
        )

        ptdat <- data %>%
          dplyr::mutate(
            y = ecdffun(val),
            color = as.character(factor(year, levels = year, labels = pal_yrs(year))),
            year = as.character(year),
            val = as.numeric(val)
          ) %>%
          na.omit

        p <- plot_ly() %>%
          add_trace(data = plodat, x = ~val,y = ~y, type = 'scatter', mode = 'lines', showlegend = FALSE, hoverinfo = 'y', inherit = FALSE,
                    line = list(color = 'black')) %>%
          add_trace(data = ptdat, x = ~val, y = ~y, inherit = FALSE, type = 'scatter', mode = 'markers',
                    hoverinfo = 'text', text = ~year, showlegend = FALSE, marker = list(size = 16, opacity = 0.8, color = ptdat$color)) %>%
          layout(
            yaxis = list(title = 'Percentiles', zeroline = TRUE),
            xaxis = list(title = labs[var], zeroline = TRUE),
            shapes = show_tdlcrkline(var, thrsel = thrsel, horiz = FALSE),
            annotations = show_tdlcrkline(var, thrsel = thrsel, horiz = FALSE, annotate = TRUE)
          )

        return(p)

      })
    )

  p1 <- plos$plo[[1]]
  p2 <- plos$plo[[2]]
  p3 <- plos$plo[[3]]
  p4 <- plos$plo[[4]]
  p5 <- plos$plo[[5]]
  p6 <- plos$plo[[6]]

  out <- subplot(p1, p2, p3, p4, p5, p6, nrows = 2, shareY = TRUE, titleX = TRUE, margin = c(0.02, 0.02, 0.1, 0.1)) %>%
    config(
      toImageButtonOptions = list(
        format = "svg",
        filename = "myplot"
      )
    )

  return(out)

}


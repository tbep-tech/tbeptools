#' Plotly barplots of tidal creek context indicators
#'
#' Plotly barplots of tidal creek context indicators
#'
#' @param selcrk numeric indicating the \code{id} number of the tidal creek to plot
#' @param cntdat output from \code{\link{anlz_tdlcrkindic}}
#' @param yr numeric indicating reference year, almost always 2018
#' @param thrsel logical if threshold lines and annotations are shown on the plots
#'
#' @return A plotly object
#' @export
#'
#' @importFrom plotly layout plot_ly subplot
#'
#' @examples
#' cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018)
#' show_tdlcrkindic(197, cntdat, thrsel = T)
show_tdlcrkindic <- function(selcrk, cntdat, yr = 2018, thrsel = FALSE){

  labs <- c('Chla (ug/L)', 'TN (mg/L)', 'Chla:TN', 'DO (mg/L)', 'Florida TSI', 'Nitrate ratio')
  names(labs) <- c('CHLAC', 'TN', 'chla_tn_ratio', 'DO', 'tsi', 'no23_ratio')

  pal_yrs <- leaflet::colorFactor(
    palette = c('#5C4A42', '#427355', '#004F7E'), #RColorBrewer::brewer.pal(8,  'Blues'),#c('#004F7E', '#00806E', '#427355', '#5C4A42', '#958984'),
    na.color = 'yellow',
    levels = as.character(seq(2008, 2017))
  )

  # data to plot
  toplo <- cntdat %>%
    filter(id %in% selcrk) %>%
    mutate(year = factor(year, levels = seq(yr - 10, yr - 1))) %>%
    tidyr::complete(id, wbid, JEI, class, year, fill = list(CHLAC = 0, DO = 0, TN = 0, chla_tn_ratio = 0, tsi = 0, no23_ratio = 0)) %>%
    mutate(color = pal_yrs(year))

  if(nrow(toplo) == 0)
    return()

  p1 <- plot_ly(toplo, x = ~year, y = ~CHLAC, type = 'bar', text = ~round(CHLAC, 1), textposition = 'auto',
                marker = list(color = ~color), hoverinfo = 'x'
  ) %>%
    layout(
      yaxis = list(title = labs['CHLAC']),
      xaxis = list(title = ''),
      showlegend = F,
      shapes = addline('CHLAC', thrsel = thrsel),
      annotations = addline('CHLAC', thrsel = thrsel, annotate = T)
    )

  p2 <- plot_ly(toplo, x = ~year, y = ~TN, type = 'bar', text = ~round(TN, 1), textposition = 'auto',
                marker = list(color = ~color), hoverinfo = 'x'
  ) %>%
    layout(
      yaxis = list(title = labs['TN']),
      xaxis = list(title = ''),
      showlegend = F,
      shapes = addline('TN', thrsel = thrsel),
      annotations = addline('TN', thrsel = thrsel, annotate = T)
    )

  p3 <- plot_ly(toplo, x = ~year, y = ~chla_tn_ratio, type = 'bar', text = ~round(chla_tn_ratio, 1), textposition = 'auto',
                marker = list(color = ~color), hoverinfo = 'x'
  ) %>%
    layout(
      yaxis = list(title = labs['chla_tn_ratio']),
      xaxis = list(title = ''),
      showlegend = F,
      shapes = addline('chla_tn_ratio', thrsel = thrsel),
      annotations = addline('chla_tn_ratio', thrsel = thrsel, annotate = T)
    )

  p4 <- plot_ly(toplo, x = ~year, y = ~DO, type = 'bar', text = ~round(DO, 1), textposition = 'auto',
                marker = list(color = ~color), hoverinfo = 'x'
  ) %>%
    layout(
      yaxis = list(title = labs['DO']),
      xaxis = list(title = ''),
      showlegend = F,
      shapes = addline('DO', thrsel = thrsel),
      annotations = addline('DO', thrsel = thrsel, annotate = T)
    )

  p5 <- plot_ly(toplo, x = ~year, y = ~tsi, type = 'bar', text = ~round(tsi, 0), textposition = 'auto',
                marker = list(color = ~color), hoverinfo = 'x'
  ) %>%
    layout(
      yaxis = list(title = labs['tsi']),
      xaxis = list(title = ''),
      showlegend = F,
      shapes = addline('tsi', thrsel = thrsel),
      annotations = addline('tsi', thrsel = thrsel, annotate = T)
    )

  p6 <- plot_ly(toplo, x = ~year, y = ~no23_ratio, type = 'bar', text = ~round(no23_ratio, 2), textposition = 'auto',
                marker = list(color = ~color), hoverinfo = 'x'
  ) %>%
    layout(
      yaxis = list(title = labs['no23_ratio'], rangemode = 'nonnegative'),
      xaxis = list(title = ''),
      showlegend = F,
      shapes = addline('no23_ratio', thrsel = thrsel),
      annotations = addline('no23_ratio', thrsel = thrsel, annotate = T)
    )

  out <- subplot(p1, p2, p3, p4, p5, p6, shareX = T, titleY = T, nrows = 3)

  return(out)

}

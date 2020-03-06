#' Plotly barplots of tidal creek context indicators
#'
#' Plotly barplots of tidal creek context indicators
#'
#' @param id numeric indicating the \code{id} number of the tidal creek to plot
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
#' show_tdlcrkindic(495, cntdat, thrsel = TRUE)
show_tdlcrkindic <- function(id, cntdat, yr = 2018, thrsel = FALSE){

  labs <- c('Chla (ug/L)', 'TN (mg/L)', 'Chla:TN', 'DO (mg/L)', 'Florida TSI', 'Nitrate ratio')
  names(labs) <- c('CHLAC', 'TN', 'chla_tn_ratio', 'DO', 'tsi', 'no23_ratio')

  pal_yrs <- leaflet::colorFactor(
    palette = c('#5C4A42', '#427355', '#004F7E'), #RColorBrewer::brewer.pal(8,  'Blues'),#c('#004F7E', '#00806E', '#427355', '#5C4A42', '#958984'),
    na.color = 'yellow',
    levels = as.character(seq(2008, 2017))
  )

  # data to plot
  toplo <- cntdat %>%
    dplyr::filter(id %in% !!id) %>%
    dplyr::mutate(year = factor(year, levels = seq(yr - 10, yr - 1))) %>%
    tidyr::complete(id, wbid, JEI, class, year, fill = list(CHLAC = 0, DO = 0, TN = 0, chla_tn_ratio = 0, tsi = 0, no23_ratio = 0)) %>%
    dplyr::mutate(color = pal_yrs(year))

  if(nrow(toplo) == 0)
    return()

  plos <- toplo %>%
    tidyr::gather('var', 'val', -id, -wbid, -JEI, -class, -year, -color) %>%
    dplyr::filter(var %in% names(labs)) %>%
    dplyr::group_by(id, wbid, JEI, class, var) %>%
    tidyr::nest() %>%
    dplyr::ungroup() %>%
    dplyr::mutate(var = factor(var, levels = names(labs))) %>%
    dplyr::arrange(var) %>%
    mutate(
      plo = purrr::pmap(list(var, data), function(var, data){

        var <- as.character(var)

        plodat <- data %>%
          mutate(val = as.numeric(val))

        p <- plot_ly(plodat, x = ~year, y = ~val, type = 'bar', text = ~round(val, 1), textposition = 'auto',
                      marker = list(color = ~color), hoverinfo = 'x'
          ) %>%
            layout(
              yaxis = list(title = labs[var], rangemode = 'nonnegative'),
              xaxis = list(title = ''),
              showlegend = FALSE,
              shapes = show_tdlcrkline(var, thrsel = thrsel),
              annotations = show_tdlcrkline(var, thrsel = thrsel, annotate = T)
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

  out <- subplot(p1, p2, p3, p4, p5, p6, shareX = TRUE, titleY = TRUE, nrows = 3)

  return(out)

}

#' Plotly barplots of tidal creek context indicators
#'
#' Plotly barplots of tidal creek context indicators
#'
#' @param id numeric indicating the \code{id} number of the tidal creek to plot
#' @param cntdat output from \code{\link{anlz_tdlcrkindic}}
#' @param yr numeric indicating reference year
#' @param thrsel logical if threshold lines and annotations are shown on the plots
#' @param pal vector of colors for the palette
#'
#' @return A plotly object
#' @export
#'
#' @concept show
#'
#' @importFrom plotly layout plot_ly subplot
#'
#' @examples
#' cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2022)
#'
#' set.seed(123)
#' id <- sample(unique(cntdat$id), 1)
#' show_tdlcrkindic(id, cntdat, thrsel = TRUE)
show_tdlcrkindic <- function(id, cntdat, yr = 2022, thrsel = FALSE, pal = c('#5C4A42', '#427355', '#004F7E')){

  labs <- c('Chla (ug/L)', 'TN (mg/L)', 'Chla:TN', 'DO (mg/L)', 'Florida TSI', 'Nitrate ratio')
  names(labs) <- c('CHLAC', 'TN', 'chla_tn_ratio', 'DO', 'tsi', 'no23_ratio')

  pal_yrs <- leaflet::colorFactor(
    palette = pal,
    na.color = 'yellow',
    levels = as.character(seq(yr - 9, yr))
  )

  browser()
  # data to plot
  toplo <- cntdat %>%
    dplyr::filter(id %in% !!id) %>%
    dplyr::mutate(year = factor(year, levels = seq(yr - 9, yr))) %>%
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

  out <- subplot(p1, p2, p3, p4, p5, p6, shareX = TRUE, titleY = TRUE, nrows = 3, margin = 0.04) %>%
    plotly::config(
      toImageButtonOptions = list(
        format = "svg",
        filename = "myplot"
      )
    )

  return(out)

}

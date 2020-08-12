#' Plot the tidal creek report card matrix
#'
#' Plot the tidal creek report card matrix
#'
#' @param dat input creek score data returned from \code{\link{anlz_tdlcrk}}
#' @param class character vector indicating which creek classes to show, one to many of \code{'3M'}, \code{'2'}, \code{'3F'}, and \code{'1'}.  Defaults to marine only (\code{'3M', '2'}).
#' @param score character vector of score categories to include, one to many of \code{'Prioritize'}, \code{'Investigate'}, \code{'Caution'}, and \code{'Monitor'}. Defaults to all.
#' @param family optional chr string indicating font family for text labels
#'
#' @details The plot shows a matrix with rows for individual creeks and columns for overall creek score.  The columns show an overall creek score and the number of years in the prior ten years that nitrogen values at a creek were assigned to each of the four score categories.  Number of years is mapped to cell transparency.
#'
#' @return A static \code{\link[ggplot2]{ggplot}} object is returned.
#'
#' @export
#'
#' @importFrom magrittr "%>%"
#' @import patchwork
#'
#' @examples
#' dat <- anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2018)
#' show_tdlcrkmatrix(dat)
show_tdlcrkmatrix <- function(dat, class = c('3M', '2'), score = c('Prioritize', 'Investigate', 'Caution', 'Monitor'), family = NA){

  # sanity checks
  if(any(!class %in% c('3M', '2', '3F', '1')))
    stop('class must be from 3M, 2, 3F, 1')

  if(any(!score %in% c('Prioritize', 'Investigate', 'Caution', 'Monitor')))
    stop('score must be from Prioritize, Investigate, Caution, Monitor')

  # named color vector
  cols <- list(Monitor = 'green', Caution = 'yellow', Investigate = 'orange', Prioritize = 'coral')

  # overall score categories
  toplo2 <- dat %>%
    dplyr::filter(class %in% !!class) %>%
    dplyr::filter(score %in% !!score) %>%
    dplyr::select(-id, -JEI, -class) %>%
    dplyr::mutate(
      name  = dplyr::case_when(
        name == '' ~ 'no name',
        T ~ name
      )
    ) %>%
    tidyr::unite('id', wbid, name, sep = ', ') %>%
    dplyr::mutate(
      score = factor(score, levels =  rev(c('Prioritize', 'Investigate', 'Caution', 'Monitor')))
    ) %>%
    dplyr::filter(!duplicated(id)) %>%
    dplyr::arrange(score, id) %>%
    dplyr::mutate(
      id = factor(id, levels = id)
    )

  # individual year counts
  toplo1 <- toplo2 %>%
    tidyr::gather('indyr', 'count', monitor, caution, investigate, prioritize) %>%
    dplyr::mutate(
      count = dplyr::case_when(
        is.na(count) ~ 0L,
        T ~ count
      ),
      indyr = factor(indyr, levels = rev(c('prioritize', 'investigate', 'caution', 'monitor')), labels = rev(c('Prioritize', 'Investigate', 'Caution', 'Monitor')))
    )

  # theme
  pthm <- ggplot2::theme(
    legend.position = 'top',
    axis.text.y = ggplot2::element_text(size  = 6, family = family),
    panel.background = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_text(size = 8, family = family),
    text = ggplot2::element_text(family = family)
  )

  # plot for individual year counts
  p1 <- ggplot2::ggplot(toplo1, ggplot2::aes(y = id, x = indyr, fill = indyr, alpha = count)) +
    ggplot2::scale_fill_manual(values = cols, guide = 'none') +
    ggplot2::geom_tile(colour = NA) +
    ggplot2::scale_alpha_continuous('Years', range = c(0, 1), limits = c(0, 10), breaks = c(0, 5, 10)) +
    ggplot2::scale_x_discrete(expand = c(0,0)) +
    ggplot2::scale_y_discrete(expand = c(0,0)) +
    ggplot2::labs(
      x = 'Individual year results',
      y = 'Creek Id, name'
      ) +
    pthm

  # plot for overall score categories
  p2 <- ggplot2::ggplot(toplo2, ggplot2::aes(y = id, x = 'Final category', fill = score)) +
    ggplot2::scale_fill_manual(values = cols, guide = ggplot2::guide_legend(reverse = T)) +
    ggplot2::geom_tile(colour = 'black') +
    ggplot2::scale_x_discrete(expand = c(0,0)) +
    ggplot2::scale_y_discrete(expand = c(0,0)) +
    pthm +
    ggplot2::theme(
      axis.text.y = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank(),
      legend.position = 'right',
      axis.title = ggplot2::element_blank()
    )

  # combine
  out <- p1 + p2 + plot_layout(ncol = 2, widths = c(1, 0.2))

  return(out)

}

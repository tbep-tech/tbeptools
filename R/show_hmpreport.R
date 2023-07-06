#' Show Habitat Master Plan progress report card
#'
#' Show Habitat Master Plan progress report card
#'
#' @param acres \code{data.frame} for intertidal and supratidal land use and cover of habitat types for each year of data
#' @param subtacres \code{data.frame} for subtidal cover of habitat types for each year of data
#' @param hmptrgs \code{data.frame} of Habitat Master Plan targets and goals
#' @param typ character string indicating \code{"targets"} or \code{"goals"}
#' @param combined logical indicating if subtidal and inter/supratidal habitat types are plotted together, see details
#' @param text logical indicating if proportion of target or goal met for habitat types is shown in each cell types
#' @param family optional chr string indicating font family for text labels
#' @param plotly logical if matrix is created using plotly
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot2}} object showing overall progress in attaining Habitat Master Plan targets or goals.
#'
#' @details Colors indicate target or goal not met, trending below (red), target or goal met, trending below (yellow), target or goal not met, trending above (light green), and target or goal  met, trending above (green).  Numbers in cell show the proportion of the target or goal met at each year where data are available.
#'
#' The report card provides no information on artificial reefs, living shorelines, and hard bottom habitats.  These habitats are not assessed in routine data products from the Southwest Florida Water Management District, although targets and goals are provided in the Habitat Master Plan.
#'
#' The subtidal data in \code{subtacres} and the inter/supratidal data in \code{acres} are provided as different datasets by the Southwest Florida Water Management District.  The years in each dataset typically do not match.  By default, results for both datasets are plotted on the same y axis for year, where gaps are shown in years where each dataset was unavailable.  Use \code{combined = FALSE} to create two separate plots with no gaps.
#'
#' @concept show
#'
#' @import patchwork
#'
#' @export
#'
#' @examples
#' # view summarized data for report card, targets
#' show_hmpreport(acres, subtacres, hmptrgs, typ = "targets")
#'
#' # view summarized data for report card, goals
#' show_hmpreport(acres, subtacres, hmptrgs, typ = "goals")
show_hmpreport <- function(acres, subtacres, hmptrgs, typ, combined = TRUE, text = TRUE, family = NA, plotly = FALSE, width = NULL, height = NULL){

  typ <- match.arg(typ, choices = c('targets', 'goals'))

  hmpsum <- anlz_hmpreport(acres = acres, subtacres = subtacres, hmptrgs = hmptrgs)

  toplo <- hmpsum %>%
    dplyr::select(year, metric, Acres, category, Target, Goal, targetprop, goalprop, targeteval, goaleval) %>%
    dplyr::filter(!metric %in% c('Restorable', 'Developed', 'Open Water')) %>%
    dplyr::mutate(
      year = as.numeric(year),
      targeteval = as.character(targeteval),
      goaleval = as.character(goaleval),
      metric = factor(metric,
                      levels = c("Tidal Flats", "Seagrasses", "Oyster Bars",
                                 "Total Intertidal", "Mangrove Forests", "Salt Barrens",
                                 "Salt Marshes", "Coastal Uplands", "Non-Forested Freshwater Wetlands",
                                 "Forested Freshwater Wetlands", "Native Uplands")
      )
    )

  # -1, 0, 0.5, 1
  cols <- c('#CC3231', '#E9C318', '#AEFA2F', '#2DC938')

  if(typ == 'targets'){

    leglabs <- c('Target not met,\ntrending below', 'Target met,\ntrending below', 'Target not met,\ntrending above', 'Target met,\ntrending above')
    ttl <- '2030 target report card'

    toplo <- toplo %>%
      dplyr::rename(
        fillv = targeteval,
        textv = targetprop
      )

  }

  if(typ == 'goals'){

    leglabs <- c('Goals not met,\ntrending below', 'Goals met,\ntrending below', 'Goals not met,\ntrending above', 'Goals met,\ntrending above')
    ttl <- '2050 goal report card'

    toplo <- toplo %>%
      dplyr::rename(
        fillv = goaleval,
        textv = goalprop
        )

  }

  toplo <- toplo %>%
    dplyr::mutate(
      fillv = factor(fillv, levels = c("-1", "0", "0.5", "1"), labels = leglabs)
    )

  thm <- ggplot2::theme_bw(base_family = family) +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      text = element_text(family = family),
      axis.text.x = ggplot2::element_text(angle = 25, hjust = 0, size = 8, family = family),
      plot.margin = ggplot2::margin(0, 5, 14, 2, "pt")
    )

  if(combined){

      p <- ggplot2::ggplot(toplo, ggplot2::aes(y = year, x = metric, fill = fillv)) +
        ggplot2::geom_tile(color = 'black') +
        ggplot2::scale_y_reverse(breaks = seq(min(toplo$year), max(toplo$year)), expand = c(0, 0)) +
        ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
        ggplot2::scale_fill_manual(
          values = cols,
          labels = leglabs
        ) +
        thm +
        ggplot2::geom_vline(xintercept = c(3.5, 7.5), linewidth = 0.5) +
        ggplot2::labs(
          x = NULL,
          y = NULL,
          fill = NULL,
          title = ttl
        ) +
        ggplot2::annotate('text', x = 2, y = max(toplo$year) + 1, label = 'Subtidal', size = 3, family = family) +
        ggplot2::annotate('text', x = 5.5, y = max(toplo$year) + 1, label = 'Intertidal', size = 3, family = family) +
        ggplot2::annotate('text', x = 9.5, y = max(toplo$year) + 1, label = 'Supratidal', size = 3, family = family) +
        ggplot2::coord_cartesian(ylim = c(max(toplo$year) + 1, min(toplo$year)) - 0.5, clip = "off")

    if(text)
      p <- p +
        ggplot2::geom_text(ggplot2::aes(label = textv), size = 2.5, family = family)

    if(plotly)
      p <- show_matrixplotly(p, family = family, hmp = TRUE, width = width, height = height)

  }

  if(!combined){

    toploa <- toplo %>%
      dplyr::filter(category == 'Sub') %>%
      dplyr::mutate(
        year = factor(year, levels = rev(unique(year)))
      )
    toplob <- toplo %>%
      dplyr::filter(category != 'Sub') %>%
      dplyr::mutate(
        year = factor(year, levels = rev(unique(year)))
      )

    pa <- ggplot2::ggplot(toploa, ggplot2::aes(y = year, x = metric, fill = fillv)) +
      ggplot2::geom_tile(color = 'black') +
      ggplot2::scale_y_discrete(expand = c(0, 0)) +
      ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
      ggplot2::scale_fill_manual(
        values = cols,
        labels = leglabs
      ) +
      ggplot2::annotate('text', x = 2, y = min(as.numeric(toploa$year)) - 1, label = 'Subtidal', size = 3, family = family) +
      ggplot2::coord_cartesian(ylim = c(min(as.numeric(toploa$year)) - 1, max(as.numeric(toploa$year))) + 0.5, clip = "off")

    pb <- ggplot2::ggplot(toplob, ggplot2::aes(y = year, x = metric, fill = fillv)) +
      ggplot2::geom_tile(color = 'black') +
      ggplot2::scale_y_discrete(expand = c(0, 0)) +
      ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
      ggplot2::scale_fill_manual(
        values = cols,
        labels = leglabs
      ) +
      ggplot2::geom_vline(xintercept = c(4.5), linewidth = 0.75) +
      ggplot2::annotate('text', x = 2.5, y = min(as.numeric(toplob$year)) - 0.75, label = 'Intertidal', size = 3, family = family) +
      ggplot2::annotate('text', x = 6.5, y = min(as.numeric(toplob$year)) - 0.75, label = 'Supratidal', size = 3, family = family) +
      ggplot2::coord_cartesian(ylim = c(min(as.numeric(toplob$year)) - 1, max(as.numeric(toplob$year))) + 0.5, clip = "off")

    if(text){
      pa <- pa +
        ggplot2::geom_text(ggplot2::aes(label = textv), size = 2.5, family = family)
      pb <- pb +
        ggplot2::geom_text(ggplot2::aes(label = textv), size = 2.5, family = family)
    }

    if(plotly)
      warning("Plotly not possible if combined is FALSE")

    p <- pa + pb + plot_layout(ncol = 2, guides = 'collect') +
      plot_annotation(
        title = ttl
      ) &
      thm &
      ggplot2::labs(
        x = NULL,
        y = NULL,
        fill = NULL
      )

  }

  return(p)

}

#' Show Habitat Master Plan progress report card
#'
#' Show Habitat Master Plan progress report card
#'
#' @param acres \code{data.frame} for intertidal and supratidal land use and cover of habitat types for each year of data
#' @param subtacres \code{data.frame} for subtidal cover of habitat types for each year of data
#' @param hmptrgs \code{data.frame} of Habitat Master Plan targets and goals
#' @param typ character string indicating \code{"targets"} or \code{"goals"}
#'
#' @return A \code{\link[ggplot2]{ggplot2}} object showing overall progress in attaining Habitat Master Plan targets or goals.
#'
#' @details Colors indicate target not met, trending below (red), target met, trending below (yellow), target not met, trending above (light green), and target met, trending above (green).  Numbers in cell show the proportion of the target or goal met at each year where data are available.
#'
#' @concept show
#'
#' @export
#'
#' @examples
#' # view summarized data for report card, targets
#' show_hmpreport(acres, subtacres, hmptrgs, typ = "targets")
#'
#' # view summarized data for report card, goals
#' show_hmpreport(acres, subtacres, hmptrgs, typ = "goals")
show_hmpreport <- function(acres, subtacres, hmptrgs, typ){

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

  cols <- c(`-1` = '#CC3231', `0` = '#E9C318', `0.5` = '#AEFA2F', `1` = '#2DC938')

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

  p <- ggplot2::ggplot(toplo, ggplot2::aes(y = year, x = metric, fill = fillv)) +
    ggplot2::geom_tile(color = 'black') +
    ggplot2::geom_text(ggplot2::aes(label = textv), size = 2.5) +
    ggplot2::scale_y_reverse(breaks = seq(min(toplo$year), max(toplo$year)), expand = c(0, 0)) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
    ggplot2::theme_bw() +
    ggplot2::scale_fill_manual(
      values = cols,
      labels = leglabs
    ) +
    ggplot2::geom_vline(xintercept = c(3.5, 7.5), linewidth = 0.5) +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = 25, hjust = 0, size = 8),
      plot.margin = ggplot2::margin(0, 0, 14, 2, "pt")
    ) +
    ggplot2::labs(
      x = NULL,
      y = NULL,
      fill = NULL,
      title = ttl
    ) +
    ggplot2::annotate('text', x = 2, y = 2021, label = 'Subtidal') +
    ggplot2::annotate('text', x = 5.5, y = 2021, label = 'Intertidal') +
    ggplot2::annotate('text', x = 9.5, y = 2021, label = 'Supratidal') +
    ggplot2::coord_cartesian(ylim = c(max(toplo$year) + 1, min(toplo$year)) - 0.5, clip = "off")

  return(p)

}

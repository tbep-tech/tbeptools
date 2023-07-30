#' Show Habitat Master Plan progress report card
#'
#' Show Habitat Master Plan progress report card
#'
#' @param acres \code{data.frame} for intertidal and supratidal land use and cover of habitat types for each year of data
#' @param subtacres \code{data.frame} for subtidal cover of habitat types for each year of data
#' @param hmptrgs \code{data.frame} of Habitat Master Plan targets and goals
#' @param typ character string indicating \code{"targets"} or \code{"goals"}
#' @param strata character string indicating with strata to plot, one to many of \code{"Subtidal"}, \code{"Intertidal"}, and \code{"Supratidal"}
#' @param ycollapse logical indicating if the y-axis is collapsed to year with data, see details
#' @param text numeric indicating text size for proportion of target or goal met for habitat types shown in each cell types, use \code{NULL} to suppress
#' @param family optional chr string indicating font family for text labels
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot2}} object showing overall progress in attaining Habitat Master Plan targets or goals.
#'
#' @details Colors indicate target or goal not met, trending below (red), target or goal met, trending below (yellow), target or goal not met, trending above (light green), and target or goal  met, trending above (green).  Numbers in cell show the proportion of the target or goal met at each year where data are available.
#'
#' The report card provides no information on artificial reefs, living shorelines, and hard bottom habitats.  These habitats are not assessed in routine data products from the Southwest Florida Water Management District, although targets and goals are provided in the Habitat Master Plan.
#'
#' The subtidal data in \code{subtacres} and the inter/supratidal data in \code{acres} are provided as different datasets by the Southwest Florida Water Management District.  The years in each dataset typically do not match and each dataset is collected at approximate 2 to 3 year intervals.  By default, year on the y-axis is shown as a continuous variable, where gaps are shown in years when each dataset was unavailable.  Use \code{ycollapse = TRUE} to remove years without data.
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
#'
#' # remove empty years
#' show_hmpreport(acres, subtacres, hmptrgs, typ = "targets", ycollapse = TRUE)
#'
#' # select only subtidal
#' show_hmpreport(acres, subtacres, hmptrgs, typ = "targets", ycollapse = TRUE, strata = 'Subtidal')
show_hmpreport <- function(acres, subtacres, hmptrgs, typ, strata = c('Subtidal', 'Intertidal', 'Supratidal'), ycollapse = FALSE, text = 2.5, family = NA, width = NULL, height = NULL){

  strat <- c('Subtidal', 'Intertidal', 'Supratidal')
  typ <- match.arg(typ, choices = c('targets', 'goals'))
  strata <- match.arg(strata, choices = strat, several.ok = TRUE)
  strata <- factor(strata, levels = strat[strat %in% strata])

  rm <- c('Restorable', 'Developed', 'Open Water', 'Living Shorelines', 'Hard Bottom',
          'Artificial Reefs', 'Tidal Tributaries')
  hmprm <- hmptrgs %>%
    dplyr::filter(!HMPU_TARGETS %in% rm)
  totcats <- hmprm %>%
    pull(Category) %>%
    table()
  metcats <- hmprm %>%
    pull(HMPU_TARGETS) %>%
    droplevels() %>%
    levels()

  hmpsum <- anlz_hmpreport(acres = acres, subtacres = subtacres, hmptrgs = hmptrgs)

  yrrng <- range(hmpsum$year)
  toplo <- hmpsum %>%
    dplyr::filter(!metric %in% rm) %>%
    dplyr::filter(category %in% strata) %>%
    tidyr::complete(year = yrrng[1]:yrrng[2], metric) %>%
    dplyr::mutate(
      yearfac = factor(year, levels = rev(yrrng[1]:yrrng[2])),
      year = as.numeric(yearfac),
      targeteval = as.character(targeteval),
      goaleval = as.character(goaleval),
      metric = factor(metric, levels = metcats)
    )

  if(ycollapse)
    toplo <- na.omit(toplo) %>%
      dplyr::mutate(
        metric = droplevels(metric),
        yearfac = factor(yearfac)
      ) %>%
      tidyr::complete(yearfac, metric) %>%
      dplyr::mutate(year = as.numeric(yearfac))

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

  # x axis locations of strata labels
  botlabs <- totcats[levels(strata)]
  botlabs <- c(0, cumsum(botlabs))
  botlabs <- as.numeric(0.5 + botlabs[-length(botlabs)] + diff(botlabs) / 2)

  # x axis locations of vertical lines
  xvec <- totcats[levels(strata)]
  xvec <- cumsum(xvec) + 0.5
  xvec <- xvec[-length(xvec)]

  p <- ggplot2::ggplot(toplo, aes(y = yearfac, x = metric)) +
    ggplot2::geom_tile(ggplot2::aes(fill = fillv), color = 'black') +
    ggplot2::scale_y_discrete(expand = c(0, 0)) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
    ggplot2::scale_fill_manual(
      values = cols,
      labels = leglabs,
      breaks = leglabs,
      na.value = 'white'
    ) +
    thm +
    ggplot2::geom_vline(xintercept = xvec, linewidth = 0.75) +
    ggplot2::labs(
      x = NULL,
      y = NULL,
      fill = NULL,
      title = ttl
    ) +
    ggplot2::annotate('text', x = botlabs, y = 0.5, vjust = 1.5, label = levels(strata), size = 3, family = family) +
    ggplot2::coord_cartesian(
      ylim = c(max(toplo$year) + 1, min(toplo$year)) - 0.5,
      clip = "off"
    )

  if(!is.null(text))
    p <- p +
      ggplot2::geom_text(data = na.omit(toplo), ggplot2::aes(label = textv), size = text, family = family)

  return(p)

}

#' Show Habitat Master Plan progress report card
#'
#' Show Habitat Master Plan progress report card
#'
#' @param acres \code{data.frame} for intertidal and supratidal land use and cover of habitat types for each year of data
#' @param subtacres \code{data.frame} for subtidal cover of habitat types for each year of data
#' @param hmptrgs \code{data.frame} of Habitat Master Plan targets and goals
#' @param typ character string indicating \code{"targets"} or \code{"goals"}
#' @param twocol logical indicating only two colors show if target or goals are met and symbols indicate the likelihood of attaining targets or goals, see details
#' @param strata character string indicating with strata to plot, one to many of \code{"Subtidal"}, \code{"Intertidal"}, and \code{"Supratidal"}
#' @param ycollapse logical indicating if the y-axis is collapsed to year with data, see details
#' @param text numeric indicating text size for proportion of target or goal met for habitat types shown in each cell types or symbols if \code{twocol = T}, use \code{NULL} to suppress
#' @param xang numeric for angle of habitat labels on the x-axis (top)
#' @param family optional chr string indicating font family for text labels
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot2}} object showing overall progress in attaining Habitat Master Plan targets or goals.
#'
#' @details If \code{twocol = F}, colors indicate both if the target/goal is met and the likelihood of attaining the target/goal by 2030/2050.  Red indicates the target/goal is not met and will likely not be met by 2030/2050 (trending below target/goal), yellow indicates the target/goal is met although it likely will not be met by 2030/2050 (trending below target/goal), light green indicates the target/goal is not met although it will likely be met by 2030/2050 (trending above target/goal), and green indicates the target/goal is met and will likely be met by 2030/2050 (trending above target/goal).  Numbers in each cell show the proportion of the target or goal met at each year where data are available.  If \code{twocol = T}, the colors indicate if the goal is met (green) or not met (red) and the symbols in each cell indicate if the goal is likely to be met (+) or not (-) by 2030/2050.  In both cases, the colors and trends are relative to the 2030 targets or 2050 goals using the \code{typ} argument.
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
show_hmpreport <- function(acres, subtacres, hmptrgs, typ, twocol = FALSE, strata = c('Subtidal', 'Intertidal', 'Supratidal'), ycollapse = FALSE, text = 2.5, xang = 25, family = NA, width = NULL, height = NULL){

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

  if(twocol){

    cols <- cols[c(1, 4)]
    leglabs <- unique(gsub('\\,\ntrending\\sbelow$|\\,\ntrending\\sabove$', '', leglabs))

    toplo <- toplo %>%
      dplyr::mutate(
        shapv = dplyr::case_when(
          fillv %in% c('-1', '0') ~ 'Trending below',
          fillv %in% c('0.5', '1') ~ 'Trending above'
        ),
        fillv = dplyr::case_when(
          fillv %in% c('0', '1') ~ '1',
          fillv %in% c('-1', '0.5') ~ '-1'
        ),
        fillv = factor(fillv, levels = c('-1', '1'), labels = leglabs)
      )

  } else {

    toplo <- toplo %>%
      dplyr::mutate(
        fillv = factor(fillv, levels = c("-1", "0", "0.5", "1"), labels = leglabs)
      )

  }

  thm <- ggplot2::theme_bw(base_family = family) +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      text = element_text(family = family),
      axis.text.x = ggplot2::element_text(angle = xang, hjust = 0, size = 8),
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

  p <- ggplot2::ggplot(toplo, aes(y = yearfac, x = metric))

  if(!twocol)
    p <- p +
      ggplot2::geom_tile(ggplot2::aes(fill = fillv), color = 'black') +
      ggplot2::scale_fill_manual(
        values = cols,
        labels = leglabs,
        breaks = leglabs,
        na.value = 'white'
      )

  if(!is.null(text) & !twocol)
    p <- p +
      ggplot2::geom_text(data = na.omit(toplo), ggplot2::aes(label = textv), size = text, family = family)

  if(twocol){

    # Custom arrow grob function up
    my_custom_grob_up <- function(x, y, size, color) {
      length <- grid::unit(size, "mm")  # Fixed length
      dx <- length * cos(pi / 4)  # x-component of length at 45 degrees
      dy <- length * sin(pi / 4)  # y-component of length at 45 degrees

      grid::segmentsGrob(
        x0 = grid::unit(x, "npc") - dx, y0 = grid::unit(y, "npc") - dy,
        x1 = grid::unit(x, "npc") + dx, y1 = grid::unit(y, "npc") + dy,
        gp = grid::gpar(col = color, fill = color, lwd = 4),
        arrow = grid::arrow(type = "open", length = grid::unit(size, "mm"), angle = 45)
      )
    }

    geom_custom_up <- function(mapping = NULL, data = NULL, stat = "identity",
                               position = "identity", na.rm = FALSE, show.legend = NA,
                               inherit.aes = TRUE, ...) {
      ggplot2::layer(
        geom = GeomCustomUp,
        mapping = mapping,
        data = data,
        stat = stat,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...)
      )
    }

    GeomCustomUp <- ggplot2::ggproto("GeomCustom", Geom,
      required_aes = c("x", "y"),
      default_aes = ggplot2::aes(size = 3, color = "black"),
      draw_panel = function(data, panel_scales, coord) {
        coords <- coord$transform(data, panel_scales)
        grobs <- mapply(my_custom_grob_up, coords$x, coords$y, coords$size, coords$colour, SIMPLIFY = FALSE)
        grid::grobTree(do.call(grid::gList, grobs))
      },
      draw_key = draw_key_point
    )

    # Custom arrow grob function down
    my_custom_grob_down <- function(x, y, size, color) {
      length <- grid::unit(size, "mm")  # Fixed length
      dx <- length * cos(pi / 4)  # x-component of length at 45 degrees
      dy <- length * sin(pi / 4)  # y-component of length at 45 degrees

      grid::segmentsGrob(
        x0 = grid::unit(x, "npc") - dx, y0 = grid::unit(y, "npc") + dy,
        x1 = grid::unit(x, "npc") + dx, y1 = grid::unit(y, "npc") - dy,
        gp = grid::gpar(col = color, fill = color, lwd = 4),
        arrow = grid::arrow(type = "open", length = grid::unit(size, "mm"), angle = 45)
      )
    }

    geom_custom_down <- function(mapping = NULL, data = NULL, stat = "identity",
                                 position = "identity", na.rm = FALSE, show.legend = NA,
                                 inherit.aes = TRUE, ...) {
      ggplot2::layer(
        geom = GeomCustomDown,
        mapping = mapping,
        data = data,
        stat = stat,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...)
      )
    }

    GeomCustomDown <- ggplot2::ggproto("GeomCustom", Geom,
      required_aes = c("x", "y"),
      default_aes = ggplot2::aes(size = 3, color = "black"),
      draw_panel = function(data, panel_scales, coord) {
        coords <- coord$transform(data, panel_scales)
        grobs <- mapply(my_custom_grob_down, coords$x, coords$y, coords$size, coords$colour, SIMPLIFY = FALSE)
        grid::grobTree(do.call(grid::gList, grobs))
      },
      draw_key = draw_key_point
    )

    # legend drawing function up arrow
    draw_key_up <- function(data, params, size){
      params$arrow$length <- grid::unit(0.35, 'cm')
      grid::segmentsGrob(0.1, 0.1, 0.9, 0.9,
                   gp = grid::gpar(col = 'black', fill = 'black', lwd = 2, lineend = "butt"),
                   arrow = params$arrow
      )
    }

    # legend drawing function down arrow
    draw_key_down <- function(data, params, size){
      params$arrow$length <- grid::unit(0.35, 'cm')
      grid::segmentsGrob(0.1, 0.9, 0.9, 0.1,
                   gp = grid::gpar(col = 'black', fill = 'black', lwd = 2, lineend = "butt"),
                   arrow = params$arrow
      )
    }

    toplo <- toplo %>%
      dplyr::mutate(
        z = rep('Trending above', nrow(.)),
        v = rep('Trending below', nrow(.))
      ) %>%
      dplyr::filter(!is.na(fillv))

    p <- p +
      ggplot2::geom_tile(fill = NA, color = NA) +
      ggplot2::geom_point(data = toplo, ggplot2::aes(x = metric, y = yearfac, color = fillv), alpha = 0) +
      geom_custom_up(data = toplo[toplo$shapv == 'Trending above', ], ggplot2::aes(x = metric, y = yearfac, color = fillv), show.legend = F) +
      geom_custom_down(data = toplo[toplo$shapv == 'Trending below', ], ggplot2::aes(x = metric, y = yearfac, color = fillv), show.legend = F) +
      ggplot2::scale_colour_manual(values = cols) +
      ggplot2::guides(color = ggplot2::guide_legend(override.aes = list(alpha = 1, shape = 15, size = 6), order = 1)) +
      ggplot2::geom_segment(data = toplo,
        ggplot2::aes(x = metric, xend = metric, y = yearfac, yend = yearfac, linetype = z),
        arrow = grid::arrow(length = grid::unit(0.25, 'cm'), type = 'open', angle = 45),
        size = 0.7, alpha = 0,
        key_glyph = draw_key_up
        ) +
      ggplot2::geom_segment(data = toplo,
        ggplot2::aes(x = metric, xend = metric, y = yearfac, yend = yearfac, linetype = v),
        arrow = grid::arrow(length = grid::unit(0.25, 'cm'), type = 'open', angle = 45),
        size = 0.7, alpha = 0,
        key_glyph = draw_key_down
      ) +
      labs(
        linetype = NULL,
        color = NULL,
        fill = NULL
      )

  }

  p <- p +
    ggplot2::scale_y_discrete(expand = c(0, 0)) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
    thm +
    ggplot2::geom_vline(xintercept = xvec, linewidth = 1) +
    ggplot2::labs(
      x = NULL,
      y = NULL,
      fill = NULL,
      title = ttl,
      shape = NULL
    ) +
    ggplot2::annotate('text', x = botlabs, y = 0.5, vjust = 1.5, label = levels(strata), size = 3, family = family) +
    ggplot2::coord_cartesian(
      ylim = c(max(toplo$year) + 1, min(toplo$year)) - 0.5,
      clip = "off"
    )

  return(p)

}

#' @title Create a colorized table for indicator reporting
#'
#' @description Create a colorized table for indicator reporting
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param txtsz numeric for size of text in the plot, applies only if \code{tab = FALSE}
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#' @param bay_segment chr string for bay segments to include, one to all of "OTB", "HB", "MTB", "LTB"
#' @param asreact logical indicating if a \code{\link[reactable]{reactable}} object is returned
#' @param nrows if \code{asreact = TRUE}, a numeric specifying number of rows in the table
#' @param abbrev logical indicating if text labels in the plot are abbreviated as the first letter
#' @param family optional chr string indicating font family for text labels
#' @param historic logical if historic data are used from 2005 and earlier
#' @param plotly logical if matrix is created using plotly
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#'
#' @family visualize
#'
#' @return A static \code{\link[ggplot2]{ggplot}} object is returned if \code{asreact = FALSE}, otherwise a \code{\link[reactable]{reactable}} table is returned
#'
#' @seealso \code{\link{show_wqmatrix}}, \code{\link{show_segmatrix}}
#' @export
#'
#' @importFrom magrittr "%>%"
#' @importFrom reactable colDef
#'
#' @import ggplot2
#'
#' @examples
#' show_matrix(epcdata)
show_matrix <- function(epcdata, txtsz = 3, trgs = NULL, yrrng = c(1975, 2019), bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), asreact = FALSE,
                        nrows = 10, abbrev = FALSE, family = NA, historic = FALSE, plotly = FALSE, partialyr = FALSE){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # process data to plot
  avedat <- anlz_avedat(epcdata, partialyr = partialyr)
  toplo <- anlz_attain(avedat, trgs = trgs) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB'))
    )

  # replace calculated with historic
  if(historic){

    # 2006 to present is correct
    mans <- dplyr::tibble(
        yr = seq(1975, 2005),
        HB = c('r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'y', 'g', 'r', 'y', 'y', 'g', 'y', 'g', 'y', 'g', 'g', 'y', 'y', 'g', 'g', 'r', 'g', 'g', 'g', 'g', 'y', 'g', 'g'),
        LTB = c('g', 'y', 'r', 'y', 'r', 'r', 'r', 'r', 'r', 'y', 'y', 'g', 'g', 'g', 'y', 'y', 'y', 'y', 'y', 'r', 'y', 'g', 'y', 'r', 'y', 'y', 'y', 'g', 'y', 'y', 'y'),
        MTB = c('r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'y', 'r', 'r', 'y', 'y', 'y', 'r', 'r', 'y', 'r', 'r', 'y', 'y', 'y', 'g', 'g', 'g', 'y'),
        OTB = c('r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'y', 'r', 'r', 'g', 'y', 'y', 'y', 'r', 'y', 'y', 'r', 'y', 'g', 'y', 'y', 'r', 'r', 'g')
      ) %>%
      tidyr::gather('bay_segment', 'outcome', -yr) %>%
      dplyr::mutate(
        outcome = dplyr::case_when(
          outcome == 'g' ~ 'green',
          outcome == 'r' ~ 'red',
          outcome == 'y' ~ 'yellow'
        ),
        bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB'))
      )

    toplo <- toplo %>%
      dplyr::left_join(mans, by = c('bay_segment', 'yr')) %>%
      dplyr::mutate(
        outcome.x = dplyr::case_when(
          yr <= 2005 ~ outcome.y,
          T ~ outcome.x
        )
      ) %>%
      dplyr::select(bay_segment, yr, chl_la, outcome = outcome.x)

  }

  # add abbreviations if true
  if(abbrev)
    toplo <- toplo %>%
      dplyr::mutate(
        outcometxt = dplyr::case_when(
          outcome == 'red' ~ 'R',
          outcome == 'yellow' ~ 'Y',
          outcome == 'green' ~ 'G'
        )
      )
  if(!abbrev)
    toplo <- toplo %>%
      dplyr::mutate(
        outcometxt = outcome
      )

  # reactable object
  if(asreact){

    totab <- toplo %>%
      dplyr::select(bay_segment, yr, outcometxt) %>%
      tidyr::spread(bay_segment, outcometxt)

    colfun <- function(x){

      out <- dplyr::case_when(
        x %in% c('R', 'red') ~ '#FF3333',
        x %in% c('Y', 'yellow') ~ '#F9FF33',
        x %in% c('G', 'green') ~ '#33FF3B'
      )

      return(out)

    }


    # make reactable
    out <- show_reactable(totab, colfun, nrows = nrows)

    return(out)

  }

  # add descriptive labels, Action
  lbs <- dplyr::tibble(
    outcome = c('red', 'yellow', 'green'),
    Action = c('On Alert', 'Caution', 'Stay the Course')
  )
  toplo <- toplo %>%
    dplyr::left_join(lbs, by = 'outcome') %>%
    tidyr::separate(chl_la, c('chl', 'la'), sep = '_', remove = F) %>%
    dplyr::mutate(
      chl = paste0('chla: ', chl),
      la = paste0('la: ', la)
    ) %>%
    tidyr::unite(chl_la, c('chl', 'la'), sep = ', ') %>%
    dplyr::mutate(
      chl_la = paste0('(', chl_la, ')')
      ) %>%
    unite(Action, c('Action', 'chl_la'), sep = ' ')

  # ggplot
  p <- ggplot(toplo, aes(x = bay_segment, y = yr, fill = outcome)) +
    geom_tile(aes(group = Action), colour = 'black') +
    scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    scale_x_discrete(expand = c(0, 0), position = 'top') +
    scale_fill_manual(values = c(red = 'red', yellow = 'yellow', green = 'green')) +
    theme_bw() +
    theme(
      axis.title = element_blank(),
      legend.position = 'none'
    )

  if(!is.null(txtsz))
    p <- p +
      geom_text(aes(label = outcometxt), size = txtsz, family = family)

  if(partialyr)
    p <- p +
      labs(caption = paste0('*Incomplete data for ', max(yrrng), ' estimated by five year average'))

  if(plotly)
    p <- show_matrixplotly(p, family = family, tooltip = 'Action')

  return(p)

}

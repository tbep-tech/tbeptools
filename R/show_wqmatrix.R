#' @title Create a colorized table for chlorophyll or light attenuation exceedances
#'
#' @description Create a colorized table for chlorophyll or light attenuation exceedances
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param param chr string for which parameter to plot, one of \code{"chla"} for chlorophyll or \code{"la"} for light attenuation
#' @param txtsz numeric for size of text in the plot, applies only if \code{tab = FALSE}
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#' @param bay_segment chr string for bay segments to include, one to all of "OTB", "HB", "MTB", "LTB"
#' @param asreact logical indicating if a \code{\link[reactable]{reactable}} object is returned
#' @param nrows if \code{asreact = TRUE}, a numeric specifying number of rows in the table
#' @param abbrev logical indicating if text labels in the plot are abbreviated as the first letter
#' @param family optional chr string indicating font family for text labels
#' @param plotly logical if matrix is created using plotly
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#'
#' @family visualize
#'
#' @return A static \code{\link[ggplot2]{ggplot}} object is returned if \code{asreact = FALSE}, otherwise a \code{\link[reactable]{reactable}} table is returned
#'
#' @seealso \code{\link{show_matrix}}, \code{\link{show_segmatrix}}
#' @export
#'
#' @importFrom magrittr "%>%"
#'
#' @import ggplot2
#'
#' @examples
#' show_wqmatrix(epcdata)
show_wqmatrix <- function(epcdata, param = c('chla', 'la'), txtsz = 3, trgs = NULL, yrrng = c(1975, 2019), bay_segment = c('OTB', 'HB', 'MTB', 'LTB'),
                          asreact = FALSE, nrows = 10, abbrev = FALSE, family = NA, plotly = FALSE, partialyr = FALSE){

  # sanity checks
  param <- match.arg(param)

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # process data to plot
  avedat <- anlz_avedat(epcdata, partialyr = partialyr) %>%
    .$ann
  toplo <- avedat %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::filter(var %in% !!paste0('mean_', param)) %>%
    dplyr::left_join(trgs, by = 'bay_segment') %>%
    dplyr::select(bay_segment, yr, var, val, thresh = !!paste0(param, '_thresh')) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB')),
      outcome = dplyr::case_when(
        val < thresh ~ 'green',
        val >= thresh ~ 'red'
      )
    )

  if(abbrev)
    toplo <- toplo %>%
      dplyr::mutate(
        outcometxt = dplyr::case_when(
          outcome == 'red' ~ 'R',
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
        x %in% c('G', 'green') ~ '#33FF3B'
      )

      return(out)

    }

    # make reactable
    out <- show_reactable(totab, colfun, nrows = nrows)

    return(out)

  }

  # add descriptive labels, Result
  lbs <- dplyr::tibble(
    outcome = c('red', 'green'),
    Result = c('Above', 'Below')
  )
  if(param == 'chla')
    rndval <- 1
  if(param == 'la')
    rndval <- 2
  toplo <- toplo %>%
    dplyr::left_join(lbs, by = 'outcome') %>%
    dplyr::mutate(
      val = paste0('Average: ', round(val, rndval)),
      thresh = paste0('Threshold: ', round(thresh, rndval))
    ) %>%
    tidyr::unite(segval, c('val', 'thresh'), sep = ', ') %>%
    dplyr::mutate(
      segval = paste0('(', segval, ')')
    ) %>%
    unite(Result, c('Result', 'segval'), sep = ' ')

  # ggplot
  p <- ggplot(toplo, aes(x = bay_segment, y = yr, fill = outcome)) +
    geom_tile(aes(group = Result), colour = 'black') +
    scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    scale_x_discrete(expand = c(0, 0), position = 'top') +
    scale_fill_manual(values = c(red = 'red', green = 'green')) +
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
      labs(caption = paste0('*Incomplete data for ', max(yrrng), ' estimated\nby five year average'))

  if(plotly)
    p <- show_matrixplotly(p, family = family, tooltip = 'Result')

  return(p)

}

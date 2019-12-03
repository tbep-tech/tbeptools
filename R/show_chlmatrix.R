#' @title Create a colorized table for chlorophyll exceedances
#'
#' @description Create a colorized table for chlorophyll exceedances
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param txtsz numeric for size of text in the plot, applies only if \code{tab = FALSE}
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#' @param asreact logical indicating if a \code{\link[reactable]{reactable}} object is returned
#' @param nrows if \code{asreact = TRUE}, a numeric specifying number of rows in the table
#'
#' @family visualize
#'
#' @return A static \code{\link[ggplot2]{ggplot}} object is returned if \code{asreact = FALSE}, otherwise a \code{\link[reactable]{reactable}} table is returned
#'
#' @seealso \code{\link{show_matrix}}
#' @export
#'
#' @importFrom magrittr "%>%"
#'
#' @import ggplot2
#'
#' @examples
#' show_chlmatrix(epcdata)
show_chlmatrix <- function(epcdata, txtsz = 3, trgs = NULL, yrrng = c(1975, 2018), asreact = FALSE, nrows = 10){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # process data to plot
  avedat <- anlz_avedat(epcdata) %>%
    .$ann
  toplo <- avedat %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(var %in% 'mean_chla') %>%
    dplyr::left_join(trgs, by = 'bay_segment') %>%
    dplyr::select(bay_segment, yr, var, val, chla_thresh) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB')),
      outcome = dplyr::case_when(
        val < chla_thresh ~ 'green',
        val >= chla_thresh ~ 'red'
      )
    )

  # reactable object
  if(asreact){

    totab <- toplo %>%
      dplyr::select(bay_segment, yr, outcome) %>%
      tidyr::spread(bay_segment, outcome)

    colfun <- function(x){

      out <- dplyr::case_when(
        x == 'red' ~ '#FF3333',
        x == 'green' ~ '#33FF3B'
      )

      return(out)

    }

    # make reactable
    out <- show_reactable(totab, colfun, nrows = nrows)

    return(out)

  }

  # ggplot
  p <- ggplot(toplo, aes(x = bay_segment, y = yr)) +
    geom_tile(colour = 'black', fill = toplo$outcome) +
    scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    scale_x_discrete(expand = c(0, 0), position = 'top') +
    theme_bw(base_family = 'serif') +
    theme(
      axis.title = element_blank(),
      text = element_text(family = 'serif')
    )

  if(!is.null(txtsz))
    p <- p +
      geom_text(aes(label = outcome), size = txtsz)

  return(p)

}

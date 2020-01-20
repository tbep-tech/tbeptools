#' @title Create a colorized table for indicator reporting
#'
#' @description Create a colorized table for indicator reporting
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param txtsz numeric for size of text in the plot, applies only if \code{tab = FALSE}
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#' @param asreact logical indicating if a \code{\link[reactable]{reactable}} object is returned
#' @param nrows if \code{asreact = TRUE}, a numeric specifying number of rows in the table
#' @param abbrev logical indicating if text labels in the plot are abbreviated as the first letter
#'
#' @family visualize
#'
#' @return A static \code{\link[ggplot2]{ggplot}} object is returned if \code{asreact = FALSE}, otherwise a \code{\link[reactable]{reactable}} table is returned
#'
#' @seealso \code{\link{show_chlmatrix}}
#' @export
#'
#' @importFrom magrittr "%>%"
#' @importFrom reactable colDef
#'
#' @import ggplot2
#'
#' @examples
#' show_matrix(epcdata)
show_matrix <- function(epcdata, txtsz = 3, trgs = NULL, yrrng = c(1975, 2018), asreact = FALSE, nrows = 10, abbrev = FALSE){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # process data to plot
  avedat <- anlz_avedat(epcdata)
  toplo <- anlz_attain(avedat, trgs = trgs) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB'))
    ) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2])

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

  # ggplot
  p <- ggplot(toplo, aes(x = bay_segment, y = yr)) +
    geom_tile(colour = 'black', fill = toplo$outcome) +
    scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    scale_x_discrete(expand = c(0, 0), position = 'top') +
    theme_bw() +
    theme(
      axis.title = element_blank()
    )

  if(!is.null(txtsz))
    p <- p +
      geom_text(aes(label = outcometxt), size = txtsz)

  return(p)

}

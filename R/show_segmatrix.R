#' @title Create a colorized table for water quality outcomes and exceedances by segment
#'
#' @description Create a colorized table for water quality outcomes by segment that includes the management action and chlorophyll, and light attenuation exceedances
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param txtsz numeric for size of text in the plot, applies only if \code{tab = FALSE}
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#' @param bay_segment chr string for bay segments to include, only one of "OTB", "HB", "MTB", "LTB"
#' @param abbrev logical indicating if text labels in the plot are abbreviated as the first letter
#' @param family optional chr string indicating font family for text labels
#' @param historic logical if historic data are used from 2005 and earlier
#' @param plotly logical if matrix is created using plotly
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A static \code{\link[ggplot2]{ggplot}} object is returned
#'
#' @concept show
#'
#' @details This function provides a combined output for the \code{\link{show_wqmatrix}} and \code{\link{show_matrix}} functions. Only one bay segment can be plotted for each function call.
#'
#' @seealso \code{\link{show_wqmatrix}}, \code{\link{show_matrix}}
#'
#' @importFrom dplyr "%>%"
#'
#' @import ggplot2
#'
#' @export
#'
#' @examples
#' show_segmatrix(epcdata, bay_segment = 'OTB')
show_segmatrix <- function(epcdata, txtsz = 3, trgs = NULL, yrrng = c(1975, 2023), bay_segment = c('OTB', 'HB', 'MTB', 'LTB'),
                           abbrev = FALSE, family = NA, historic = TRUE, plotly = FALSE, partialyr = FALSE, width = NULL,
                           height = NULL) {

  bay_segment <- match.arg(bay_segment)

  # outcome data
  outdat <- show_matrix(epcdata, bay_segment = bay_segment, txtsz = NULL, trgs = trgs, yrrng = yrrng, historic = historic, abbrev = abbrev)
  outdat <- outdat$data %>%
    dplyr::mutate(
      var = 'outcome',
      bay_segment = as.character(bay_segment)
      ) %>%
    dplyr::select(bay_segment, yr, var, Action, outcome, outcometxt)

  # chloropyll and la data
  chldat <- show_wqmatrix(epcdata, param = 'chl', bay_segment = bay_segment, trgs = trgs, txtsz = NULL, yrrng = yrrng, abbrev = abbrev)
  chldat <- chldat$data
  ladat <- show_wqmatrix(epcdata, param = 'la', bay_segment = bay_segment, trgs = trgs, txtsz = NULL, yrrng = yrrng, abbrev = abbrev)
  ladat <- ladat$data
  wqdat <- dplyr::bind_rows(chldat, ladat) %>%
    dplyr::rename(Action = Result) %>%
    dplyr::select(-Action) %>%
    dplyr::mutate(
      var = gsub('^mean\\_', '', var),
      bay_segment = as.character(bay_segment)
    )

  # outcome results for chlorophyll and la, e.g., large/small, short/long exceedances
  vals <- anlz_avedat(epcdata, partialyr = partialyr) %>%
    anlz_attain(magdurout = T) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::mutate(
      mags = factor(mags, levels = c(0, 1, 2), labels = c('none', 'small', 'large')),
      mags = as.character(mags),
      mags = paste0('Exceedance: ', mags, ' (size)'),
      durats = case_when(
        durats %in% 0 ~ 'none',
        durats %in% c(1, 2, 3) ~ 'short',
        durats %in% 4 ~ 'long'
      ),
      durats = paste0(durats, ' (length)'),
      outcome = paste0('Outcome: ', outcome)
    ) %>%
    dplyr::select(-val, -target, -smallex, -thresh) %>%
    tidyr::unite(Action, c('outcome', 'mags', 'durats'), sep = ', ')

  # combine wqdat with outcome results and outcome data
  toplo <- wqdat %>%
    dplyr::left_join(vals, by = c('bay_segment', 'yr', 'var')) %>%
    bind_rows(outdat) %>%
    dplyr::mutate(
      var = factor(var, levels = c('la', 'outcome', 'chla'), labels = c('Light attenuation', 'Management outcome', 'Chlorophyll-a'))
    )

  # create plot
  p <- ggplot(toplo, aes(x = var, y = yr, fill = outcome)) +
    geom_tile(aes(group = Action), colour = 'black') +
    scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    scale_x_discrete(expand = c(0, 0), position = 'top') +
    scale_fill_manual(values = c(red = '#CC3231', yellow = '#E9C318', green = '#2DC938')) +
    theme_bw() +
    theme(
      axis.title = element_blank(),
      legend.position = 'none'
    )

  # text if not null
  if(!is.null(txtsz))
    p <- p +
      geom_text(aes(label = outcometxt), size = txtsz, family = family)

  if(plotly)
    p <- show_matrixplotly(p, family = family, tooltip = 'Action', width = width, height = height)

  return(p)

}

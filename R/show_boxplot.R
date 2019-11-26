#' @title Plot monthly chlorophyll values and thresholds for a segment
#'
#' @description Plot monthly chlorophyll values and thresholds for a bay segment
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param yrcur numeric for current year to emphasize, shown as separate red points on the plot
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#'
#' @family visualize
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#'
#' @export
#'
#' @import ggplot2
#' @importFrom lubridate month
#' @importFrom magrittr "%>%"
#'
#' @examples
#' show_boxplot(epcdata, bay_segment = 'OTB')
show_boxplot <- function(epcdata, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), trgs = NULL, yrrng = c(1975, 2018)){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # yrrng must be in ascending order
  if(yrrng[1] >= yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1975, 2018)')

  # segment
  bay_segment <- match.arg(bay_segment)

  # most recent year to emphasize
  curyr <- max(yrrng)

  # monthly averages
  aves <- anlz_avedat(epcdata)

  # axis label
  axlab <- expression("Mean Monthly Chlorophyll-a ("~ mu * "g\u00B7L"^-1 *")")

  # get lines to plot
  thrnum <- trgs %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(chla_thresh)

  # threshold label
  trglab <- paste(thrnum, "~ mu * g%.%L^{-1}")


  # bay segment plot title
  ttl <- trgs %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(name)

  # get data to plot
  toplo <- aves$mo %>%
    dplyr::filter(var %in% 'mean_chla') %>%
    dplyr::filter(bay_segment == !!bay_segment) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::mutate(
      var = 'yval',
      mo = month(mo, label = T)
    )

  # toplo1 is all but current year
  toplo1 <- toplo %>%
    dplyr::filter(!yr %in% curyr)

  # toplo2 is current year
  toplo2 <- toplo %>%
    dplyr::filter(yr %in% curyr)

  # colors
  cols <- c("yrrng" = "black", "curyr" = "blue")
  names(cols)[1] <- paste(yrrng, collapse = ', ')
  names(cols)[2] <- as.character(curyr)

  p <- ggplot() +
    geom_boxplot(data = toplo1, aes(x = mo, y = val, colour = 'yrrng')) +
    geom_point(data = toplo2, aes(x = mo, y = val, colour = 'curyr')) +
    geom_hline(aes(yintercept = thrnum)) +
    geom_text(aes(x = factor('Jan'), thrnum), parse = TRUE, label = trglab, hjust = 0.2, vjust = 1) +
    labs(y = axlab, title = ttl) +
    theme(axis.title.x = element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank(),
          legend.position = 'top',#c(0.85, 0.95),
          legend.background = element_rect(fill=NA),
          legend.title = element_blank(),
          axis.text.x = element_text(angle = 45, size = 7, hjust = 1)
    ) +
    scale_colour_manual(values = cols, labels = factor(names(cols), levels = names(cols))) +
    guides(colour = guide_legend(
      override.aes = list(
        shape = c(19, NA, NA, NA),
        colour = cols,
        linetype = c('solid', 'solid', 'dashed', 'dotted'),
        size = c(0.75, 0.5, 0.5, 0.5)
      )
    ))

  return(p)

}

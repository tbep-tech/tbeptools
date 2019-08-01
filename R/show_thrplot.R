#' @title Plot annual water quality values and thresholds for a segment
#'
#' @description Plot annual water quality values and thresholds for a bay segment
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param thr chr string indicating with water quality value and appropriate threshold to to plot, one of "chl" for chlorophyll and "la" for light availability
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#'
#' @family visualize
#'
#' @return A \code{\link[ggplot2]{ggplot2}} object
#'
#' @export
#'
#' @import ggplot2
#' @importFrom magrittr "%>%"
#'
#' @examples
#' show_thrplot(epcdata, bay_segment = 'OTB', thr = 'chl')
show_thrplot <- function(epcdata, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), thr = c('chla', 'la'), trgs = NULL, yrrng = c(1975, 2018)){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # segment
  bay_segment <- match.arg(bay_segment)

  # wq to plot
  thr <- match.arg(thr)

  # colors
  cols <- c("Annual Mean"="red", "Management Target"="blue", "Regulatory Threshold"="blue", "Small Mag. Exceedance"="blue", "Large Mag. Exceedance"="blue")

  # color labels
  collab <- dplyr::case_when(
    thr == 'chla' ~ 'Regulatory Threshold',
    thr == 'la' ~ 'Management Target'
  )

  # averages
  aves <- anlz_avedat(epcdata)

  # axis label
  axlab <- dplyr::case_when(
    thr == 'chla' ~ expression("Mean Annual Chlorophyll-a ("~ mu * "g\u00B7L"^-1 *")"),
    thr == 'la' ~ expression("Mean Annual Light Attenuation (m  " ^-1 *")")
  )

  # get threshold value
  thrsvl <- trgs %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(!!paste0(thr, '_thresh'))

  # threshold label
  thrlab <- dplyr::case_when(
    thr == 'chla' ~ paste(thrsvl, "~ mu * g%.%L^{-1}"),
    thr == 'la' ~ paste(thrsvl, "~m","^{-1}")
  )

  # bay segment plot title
  ttl <- trgs %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(name)

  # get data to plo
  toplo <- aves$ann %>%
    dplyr::filter(grepl(paste0('_', thr, '$'), var)) %>%
    mutate(var = 'yval') %>%
    dplyr::filter(bay_segment == !!bay_segment) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    tidyr::spread(var, val)

  p <- ggplot(toplo, aes(x = yr)) +
    geom_point(aes(y = yval, colour = "Annual Mean"), size = 3) +
    geom_line(aes(y = yval, colour = "Annual Mean"), size = 0.75) +
    geom_hline(data = trgs, aes(yintercept = thrsvl, colour = !!collab)) +
    ggtitle(ttl) +
    geom_text(aes(yrrng[1], thrsvl), parse = TRUE, label = thrlab, hjust = 0.2, vjust = -0.3) +
    ylab(axlab) +
    xlab("") +
    scale_x_continuous(breaks = seq(yrrng[1], yrrng[2], by = 1)) +
    theme(plot.title = element_text(hjust = 0.5),
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank(),
          legend.position = c(0.85, 0.95),
          legend.background = element_rect(fill=NA),
          axis.text.x = element_text(angle = 45, size = 7, hjust = 1)
    ) +
    scale_colour_manual(name="", values = cols,
                        labels=c("Annual Mean", collab))

  return(p)

}

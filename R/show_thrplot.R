#' @title Plot annual water quality values and thresholds for a segment
#'
#' @description Plot annual water quality values and thresholds for a bay segment
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param thr chr string indicating with water quality value and appropriate threshold to to plot, one of "chl" for chlorophyll and "la" for light availability
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
#' \dontrun{
#' show_thrplot(epcdata, bay_segment = 'OTB', thr = 'chl')
#' }
show_thrplot <- function(epcdata, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), thr = c('chla', 'la')){

  # segment
  bay_segment <- match.arg(bay_segment)

  # wq to plot
  thr <- match.arg(thr)

  # colors
  cols <- c("Annual Mean"="red", "Management Target"="blue", "Regulatory Threshold"="blue", "Small Mag. Exceedance"="blue", "Large Mag. Exceedance"="blue")

  # averages
  aves <- anlz_avedat(epcdata)

  # axis label
  axlab <- dplyr::case_when(
    thr == 'chla' ~ expression("Mean Annual Chlorophyll-a ("~ mu * "g\u00B7L"^-1 *")"),
    thr == 'la' ~ expression("Mean Annual Light Attenuation (m  " ^-1 *")")
  )

  # get threshold value
  thrsvl <- targets %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(!!paste0(thr, '_thresh'))

  # threshold label
  thrlab <- dplyr::case_when(
    thr == 'chla' ~ paste(thrsvl, "~ mu * g%.%L^{-1}"),
    thr == 'la' ~ paste(thrsvl, "~m","^{-1}")
  )

  # bay segment plot title
  ttl <- targets %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(name)

  # get data to plo
  toplo <- aves$ann %>%
    dplyr::filter(grepl(paste0('_', thr, '$'), var)) %>%
    mutate(var = 'yval') %>%
    dplyr::filter(bay_segment == !!bay_segment & yr < 2019) %>%
    tidyr::spread(var, val)

  p <- ggplot(toplo, aes(x = yr)) +
    geom_point(aes(y = yval, colour = "Annual Mean"), size = 3) +
    geom_line(aes(y = yval, colour = "Annual Mean"), size = 0.75) +
    geom_hline(data = targets, aes(yintercept = thrsvl, colour = "Regulatory Threshold")) +
    ggtitle(ttl) +
    geom_text(aes(1973, thrsvl), parse = TRUE, label = thrlab, hjust = 0.2, vjust = -0.3) +
    ylab(axlab) +
    xlab("") +
    scale_x_continuous(breaks = seq(1973,2019,by = 1)) +
    theme(plot.title = element_text(hjust = 0.5),
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank(),
          legend.position = c(0.88, 0.95),
          legend.background = element_rect(fill=NA),
          axis.text.x = element_text(angle = 45, size = 8, hjust = 1)
    ) +
    scale_colour_manual(name="", values = cols,
                        labels=c("Annual Mean", "Regulatory Threshold"))

  return(p)

}

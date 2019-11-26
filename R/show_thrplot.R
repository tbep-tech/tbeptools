#' @title Plot annual water quality values and thresholds for a segment
#'
#' @description Plot annual water quality values and thresholds for a bay segment
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param thr chr string indicating which water quality value and appropriate threshold to plot, one of "chl" for chlorophyll and "la" for light availability
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
#' @importFrom magrittr "%>%"
#'
#' @examples
#' show_thrplot(epcdata, bay_segment = 'OTB', thr = 'chl')
show_thrplot <- function(epcdata, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), thr = c('chla', 'la'), trgs = NULL, yrrng = c(1975, 2018)){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # yrrng must be in ascending order
  if(yrrng[1] >= yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1975, 2018)')

  # segment
  bay_segment <- match.arg(bay_segment)

  # wq to plot
  thr <- match.arg(thr)

  # color labels
  collab <- dplyr::case_when(
    thr == 'chla' ~ 'Regulatory Threshold',
    thr == 'la' ~ 'Management Target'
  )

  # colors
  cols <- c("Annual Mean"="red", "Management Target"="blue", "Regulatory Threshold"="blue", "+1 se"="blue", "+2 se"="blue")
  cols <- cols[c('Annual Mean', collab, '+1 se', '+2 se')]

  # averages
  aves <- anlz_avedat(epcdata)

  # axis label
  axlab <- dplyr::case_when(
    thr == 'chla' ~ expression("Mean Annual Chlorophyll-a ("~ mu * "g\u00B7L"^-1 *")"),
    thr == 'la' ~ expression("Mean Annual Light Attenuation (m  " ^-1 *")")
  )

  # get lines to plot
  toln <- trgs %>%
    dplyr::filter(bay_segment %in% !!bay_segment)
  trgnum <- toln %>% dplyr::pull(!!paste0(thr, '_target'))
  smlnum <- toln %>% dplyr::pull(!!paste0(thr, '_smallex'))
  thrnum <- toln %>% dplyr::pull(!!paste0(thr, '_thresh'))

  # threshold label
  trglab <- dplyr::case_when(
    thr == 'chla' ~ paste(trgnum, "~ mu * g%.%L^{-1}"),
    thr == 'la' ~ paste(trgnum, "~m","^{-1}")
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

  p <- ggplot() +
    geom_point(data = toplo, aes(x = yr, y = yval, colour = "Annual Mean"), size = 3) +
    geom_line(data = toplo, aes(x = yr, y = yval, colour = "Annual Mean"), linetype = 'solid', size = 0.75) +
    geom_hline(aes(yintercept = trgnum, colour = !!collab)) +
    geom_hline(aes(yintercept = smlnum, colour = '+1 se'), linetype = 'dashed') +
    geom_hline(aes(yintercept = thrnum, colour = '+2 se'), linetype = 'dotted') +
    geom_text(aes(yrrng[1], trgnum), parse = TRUE, label = trglab, hjust = 0.2, vjust = 1) +
    labs(y = axlab, title = ttl) +
    scale_x_continuous(breaks = seq(yrrng[1], yrrng[2], by = 1)) +
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

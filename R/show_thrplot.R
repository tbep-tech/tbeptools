#' @title Plot annual water quality values, targets, and thresholds for a segment
#'
#' @description Plot annual water quality values, targets, and thresholds for a bay segment
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param thr chr string indicating which water quality value and appropriate target/threshold to plot, one of "chl" for chlorophyll and "la" for light availability
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets/thresholds, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#' @param family optional chr string indicating font family for text labels
#' @param labelexp logical indicating if y axis and target labels are plotted as expressions, default \code{TRUE}
#' @param txtlab logical indicating if a text label for the target value is shown in the plot
#' @param thrs logical indicating if reference lines are shown only for the regulatory threshold
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#'
#' @concept show
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#'
#' @export
#'
#' @import ggplot2
#' @importFrom dplyr "%>%"
#'
#' @examples
#' show_thrplot(epcdata, bay_segment = 'OTB', thr = 'chl')
show_thrplot <- function(epcdata, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), thr = c('chla', 'la'), trgs = NULL, yrrng = c(1975, 2024),
                         family = NA, labelexp = TRUE, txtlab = TRUE, thrs = FALSE, partialyr = FALSE){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # yrrng must be in ascending order
  if(yrrng[1] >= yrrng[2])
    stop('yrrng argument must be in ascending order')

  # segment
  bay_segment <- match.arg(bay_segment)

  # wq to plot
  thr <- match.arg(thr)

  # colors
  cols <- c("Annual Mean"="red", "Management Target"="blue", "+1 se (small exceedance)"="blue", "+2 se (large exceedance)"="blue")

  # averages
  aves <- anlz_avedat(epcdata, partialyr = partialyr)

  # axis label
  if(labelexp)
    axlab <- ifelse(thr == 'chla', expression("Mean Ann. Chl-a ("~ mu * "g\u00B7L"^-1 *")"),
                    ifelse(thr == 'la', expression("Mean Ann. Light Att. (m  " ^-1 *")"), NA))
  if(!labelexp)
    axlab <- dplyr::case_when(
      thr == 'chla' ~ "Mean Ann. Chl-a (ug/L)",
      thr == 'la' ~ "Mean Ann. Light Atten. (m-1)"
    )

  # get lines to plot
  toln <- trgs %>%
    dplyr::filter(bay_segment %in% !!bay_segment)
  trgnum <- toln %>% dplyr::pull(!!paste0(thr, '_target'))
  smlnum <- toln %>% dplyr::pull(!!paste0(thr, '_smallex'))
  thrnum <- toln %>% dplyr::pull(!!paste0(thr, '_thresh'))


  # change label location if thrs is true
  if(!thrs)
    num <- trgnum
  if(thrs)
    num <- thrnum

  # threshold label
  if(labelexp)
    trglab <- dplyr::case_when(
      thr == 'chla' ~ paste(num, "~ mu * g%.%L^{-1}"),
      thr == 'la' ~ paste(num, "~m","^{-1}")
    )
  if(!labelexp)
    trglab <- dplyr::case_when(
      thr == 'chla' ~ paste(num, "ug/L"),
      thr == 'la' ~ paste(num, "m-1")
    )

  # bay segment plot title
  ttl <- trgs %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(name)

  if(partialyr)
    ttl <- paste0(ttl, '*')

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
    labs(y = axlab, title = ttl) +
    scale_x_continuous(breaks = seq(yrrng[1], yrrng[2], by = 1)) +
    theme_grey(base_family = family) +
    theme(axis.title.x = element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank(),
          panel.background = element_rect(fill = '#ECECEC'),
          legend.position = 'top',#c(0.85, 0.95),
          legend.background = element_rect(fill=NA),
          legend.key = element_rect(fill = '#ECECEC'),
          legend.title = element_blank(),
          axis.text.x = element_text(angle = 45, size = 7, hjust = 1)
    )

  # all targets/thresholds
  if(!thrs)
    p <- p +
      geom_hline(aes(yintercept = trgnum, colour = 'Management Target'), linetype = 'solid') +
      geom_hline(aes(yintercept = smlnum, colour = '+1 se (small exceedance)'), linetype = 'dashed') +
      geom_hline(aes(yintercept = thrnum, colour = '+2 se (large exceedance)'), linetype = 'dotted') +
      scale_colour_manual(values = cols, labels = factor(names(cols), levels = names(cols))) +
      guides(colour = guide_legend(
        override.aes = list(
          shape = c(19, NA, NA, NA),
          colour = cols,
          linetype = c('solid', 'solid', 'dashed', 'dotted'),
          linewidth = c(0.75, 0.5, 0.5, 0.5)
          )
      ))

  # thresholds only
  if(thrs)
    p <- p +
      geom_hline(aes(yintercept = thrnum, colour = '+2 se (large exceedance)'), linetype = 'dotted') +
      scale_colour_manual(values = cols[c(1, 4)], labels = factor(names(cols[c(1, 4)]), levels = names(cols[c(1, 4)]))) +
      guides(colour = guide_legend(
        override.aes = list(
          shape = c(19, NA),
          colour = cols[c(1, 4)],
          linetype = c('solid', 'dotted'),
          linewidth = c(0.75, 0.5)
        )
      ))

  if(txtlab & !thrs)
    p <- p +
      geom_text(aes(yrrng[1], num, label = trglab), parse = labelexp, hjust = 0.2, vjust = 1, family = family, colour = 'blue')

  if(txtlab & thrs)
    p <- p +
      geom_text(aes(yrrng[1], max(toplo$yval), label = trglab), parse = labelexp, hjust = 0.2, vjust = 1, family = family, colour = 'blue')


  if(partialyr)
    p <- p +
      labs(caption = paste0('*Incomplete data for ', max(yrrng), ' estimated by five year average'))

  return(p)

}

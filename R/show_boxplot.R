#' @title Plot monthly chlorophyll values and thresholds for a segment
#'
#' @description Plot monthly chlorophyll values and thresholds for a bay segment
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param yrsel numeric for year to emphasize, shown as separate red points on the plot
#' @param yrrng numeric vector indicating min, max years to include
#' @param ptsz numeric indicating point size of observations not in \code{yrsel}
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#'
#' @family visualize
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#'
#' @details
#' Points not included in \code{yrsel} are plotted over the box plots using \code{\link[ggbeeswarm]{geom_beeswarm}}. Use \code{ptsz = -1} to suppress.
#'
#' @export
#'
#' @import ggplot2
#' @importFrom ggbeeswarm geom_beeswarm
#' @importFrom lubridate month
#' @importFrom magrittr "%>%"
#'
#' @examples
#' show_boxplot(epcdata, bay_segment = 'OTB')
show_boxplot <- function(epcdata, yrsel = NULL, yrrng = c(1975, 2018), ptsz = 0.5, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), trgs = NULL){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # select curyr as max of yrrng if null
  if(is.null(yrsel))
    yrsel <- max(yrrng)

  # segment
  bay_segment <- match.arg(bay_segment)

  # monthly averages
  aves <- anlz_avedat(epcdata) %>%
    .$'mos' %>%
    dplyr::filter(var %in% 'mean_chla') %>%
    dplyr::filter(bay_segment == !!bay_segment) %>%
    dplyr::mutate(
      var = 'yval',
      mo = month(mo, label = T)
    )

  # yrrng must be in ascending order
  if(yrrng[1] >= yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1975, 2018)')

  # yrrng not in epcdata
  if(any(!yrrng %in% aves$yr))
    stop(paste('Check yrrng is within', paste(range(aves$yr, na.rm = TRUE), collapse = '-')))

  # yrsel not in epcdata
  if(!yrsel %in% epcdata$yr)
    stop(paste('Check yrsel is within', paste(range(epcdata$yr, na.rm = TRUE), collapse = '-')))



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

  # toplo1 is all but current year
  toplo1 <- aves %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(!yr %in% yrsel)

  # toplo2 is current year
  toplo2 <- aves %>%
    dplyr::filter(yr %in% yrsel)

  # colors and legend names
  cols <- c("black", "red")
  names(cols)[1] <- case_when(
    yrsel == yrrng[1] ~ paste(yrrng[1] + 1, yrrng[2], sep = '-'),
    yrsel == yrrng[2] ~ paste(yrrng[1], yrrng[2] - 1, sep = '-'),
    yrsel > yrrng[1] & yrsel < yrrng[2] ~ paste(paste(yrrng[1], yrsel - 1, sep = '-'), paste(yrsel + 1, yrrng[2], sep = '-'), sep = ', '),
    T ~ paste(yrrng, collapse = '-')
  )
  names(cols)[2] <- as.character(yrsel)

  p <- ggplot() +
    geom_boxplot(data = toplo1, aes(x = mo, y = val, colour = names(cols)[1]), outlier.colour = NA) +
    geom_beeswarm(data = toplo1, aes(x = mo, y = val, colour = names(cols)[1]), size = ptsz) +
    geom_point(data = toplo2, aes(x = mo, y = val, fill = names(cols)[2]), pch = 21, color = cols[2], size = 3, alpha = 0.7) +
    geom_hline(aes(yintercept = thrnum, linetype = '+2 se'), colour = 'blue') +
    geom_text(aes(x = factor('Jan'), max(aves$val)), parse = TRUE, label = trglab, hjust = 0.2, vjust = 1, colour = 'blue') +
    labs(y = axlab, title = ttl) +
    theme(axis.title.x = element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank(),
          panel.background = element_rect(fill = '#ECECEC'),
          legend.position = 'top',#c(0.85, 0.95),
          legend.background = element_rect(fill=NA),
          legend.key = element_rect(fill = '#ECECEC'),
          legend.title = element_blank(),
          axis.text.x = element_text(angle = 45, size = 8, hjust = 1)
    ) +
    scale_colour_manual(values = cols[1]) +
    scale_fill_manual(values = cols[2]) +
    scale_linetype_manual(values = 'dotted') +
    guides(linetype = guide_legend(override.aes = list(colour = 'blue')))

  return(p)

}

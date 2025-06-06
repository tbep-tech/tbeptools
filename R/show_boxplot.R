#' @title Plot monthly chlorophyll or light attenuation values for a segment
#'
#' @description Plot monthly chlorophyll or light attenuation values for a bay segment
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param param chr string for which parameter to plot, one of \code{"chla"} for chlorophyll or \code{"la"} for light attenuation
#' @param yrsel numeric for year to emphasize, shown as separate red points on the plot
#' @param yrrng numeric vector indicating min, max years to include
#' @param ptsz numeric indicating point size of observations not in \code{yrsel}
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param family optional chr string indicating font family for text labels
#' @param labelexp logical indicating if y axis and target labels are plotted as expressions, default \code{TRUE}
#' @param txtlab logical indicating if a text label for the target value is shown in the plot
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#' @param points logical indicating if jittered point observations, including outliers, are shown in the plot
#'
#' @concept show
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#'
#' @details
#' Points not included in \code{yrsel} are plotted over the box plots using \code{\link[ggplot2]{position_jitter}}. Use \code{ptsz = -1} to suppress.  The dotted line in the plot shows the large exceedance value.
#'
#' @export
#'
#' @import ggplot2
#' @importFrom lubridate month
#' @importFrom dplyr "%>%"
#'
#' @examples
#' show_boxplot(epcdata, bay_segment = 'OTB')
show_boxplot <- function(epcdata, param = c('chla', 'la'),  yrsel = NULL, yrrng = c(1975, 2024), ptsz = 0.5, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'),
                         trgs = NULL, family = NA, labelexp = TRUE, txtlab = TRUE, partialyr = FALSE, points = TRUE){

  # parameter
  param <- match.arg(param)

  # segment
  bay_segment <- match.arg(bay_segment)

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # select curyr as max of yrrng if null
  if(is.null(yrsel))
    yrsel <- max(yrrng)

  # monthly averages
  aves <- anlz_avedat(epcdata, partialyr = partialyr) %>%
    .$'mos' %>%
    dplyr::filter(var %in% !!paste0('mean_', param)) %>%
    dplyr::filter(bay_segment == !!bay_segment) %>%
    dplyr::mutate(
      var = 'yval',
      mo = month(mo, label = T)
    )

  # create month labels for x axis, asterisks if partialyr is true
  if(partialyr){

    # missing months of selected year
    mismo <- epcdata %>%
      filter(yr == !!yrsel) %>%
      anlz_avedat(partialyr = FALSE) %>%
      .[['mos']] %>%
      dplyr::select(mo) %>%
      unique() %>%
      pull(mo) %>%
      setdiff(1:12, .)
    molab <- levels(aves$mo)
    molab[mismo] <- paste0(molab[mismo], '*')

  }

  # yrrng must be in ascending order
  if(yrrng[1] >= yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1975, 2018)')

  # yrrng not in epcdata
  if(any(!yrrng %in% aves$yr))
    stop(paste('Check yrrng is within', paste(range(aves$yr, na.rm = TRUE), collapse = '-')))

  # yrsel not in epcdata
  if(!yrsel %in% epcdata$yr)
    stop(paste('Check yrsel is within', paste(range(epcdata$yr, na.rm = TRUE), collapse = '-')))

  # get lines to plot
  thrnum <- trgs %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(!!paste0(param, '_thresh'))

  # axis label
  if(labelexp)
    axlab <- ifelse(param == 'chla', expression("Mean Annual Chlorophyll-a ("~ mu * "g\u00B7L"^-1 *")"),
                    ifelse(param == 'la', expression("Mean Annual Light Attenuation (m  " ^-1 *")"), NA))
  if(!labelexp)
    axlab <- dplyr::case_when(
      param == 'chla' ~ "Mean Annual Chlorophyll-a (ug/L)",
      param == 'la' ~ "Mean Annual Light Attenuation (m-1)"
    )

  # parameshold label
  if(labelexp)
    trglab <- dplyr::case_when(
      param == 'chla' ~ paste(thrnum, "~ mu * g%.%L^{-1}"),
      param == 'la' ~ paste(thrnum, "~m","^{-1}")
    )
  if(!labelexp)
    trglab <- dplyr::case_when(
      param == 'chla' ~ paste(thrnum, "ug/L"),
      param == 'la' ~ paste(thrnum, "m-1")
    )

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
    yrsel > yrrng[1] & yrsel < yrrng[2] ~ paste(paste(unique(c(yrrng[1], yrsel - 1)), collapse = '-'), paste(unique(c(yrsel + 1, yrrng[2])), collapse = '-'), sep = ', '),
    T ~ paste(yrrng, collapse = '-')
  )
  names(cols)[2] <- as.character(yrsel)

  p <- ggplot() +
    geom_boxplot(data = toplo1, aes(x = mo, y = val, colour = names(cols)[1]), outlier.colour = NA, outliers = points)

  # add here to change order of points on plot
  if(points)
    p <- p +
      geom_point(data = toplo1, aes(x = mo, y = val, group = yr, colour = names(cols)[1]), position = position_jitter(width = 0.2), size = ptsz)

  p <- p +
    geom_point(data = toplo2, aes(x = mo, y = val, group = yr, fill = names(cols)[2]), pch = 21, color = cols[2], size = 3, alpha = 0.7) +
    geom_hline(aes(yintercept = thrnum, linetype = '+2 se (large exceedance)'), colour = 'blue') +
    labs(y = axlab, title = ttl) +
    theme_grey(base_family = family) +
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

  # show text as max observed value or 75th percentile
  if(txtlab){
    yval <- max(aves$val)
    if(!points)
      yval <- toplo1 %>%
        dplyr::summarise(
          yval = graphics::boxplot(val, plot = F)$stats[5, ],
          .by = mo
        ) %>%
      dplyr::pull(yval) %>%
      max()
    p <- p +
      geom_text(aes(x = factor('Jan'), yval), parse = labelexp, label = trglab, hjust = 0.2, vjust = 1, colour = 'blue', family = family)
  }

  if(partialyr)
    p <- p +
      scale_x_discrete(labels = molab) +
      labs(caption = paste0('*Missing data estimated by five year average from ', yrsel))

  return(p)

}

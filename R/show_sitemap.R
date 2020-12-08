#' Map site attainment categories for a selected year
#'
#' Map site attainment categories for a selected year
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param yrsel numeric for year to plot
#' @param param chr string for which parameter to plot, one of \code{"chla"} for chlorophyll or \code{"la"} for light attenuation
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param thrs logical indicating if attainment category is relative to targets (default) or thresholds, passed to \code{\link{anlz_attainsite}}
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#'
#' @family visualize
#'
#' @return A static \code{ggplot} object is returned
#'
#' @export
#'
#' @import ggplot2 sf
#'
#' @examples
#' show_sitemap(epcdata, yrsel = 2019)
show_sitemap <- function(epcdata, yrsel, param = c('chla', 'la'), trgs = NULL, thrs = FALSE, partialyr = FALSE){

  # sanity check
  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # parameter
  param <- match.arg(param)

  prj <- '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'

  # get site averages for selected year
  tomap <- epcdata %>%
    anlz_avedatsite(partialyr = partialyr) %>%
    anlz_attainsite(yrrng = yrsel, thr = param, trgs = trgs, thrs = thrs) %>%
    dplyr::left_join(stations, by = c('epchc_station', 'bay_segment')) %>%
    dplyr::mutate(
      met = factor(met, levels = c('yes', 'no'), labels = c('yes', 'no'))
    ) %>%
    st_as_sf(coords = c('Longitude', 'Latitude'), crs = prj)

  # legend label
  leglab <- paste0('Target met\nin ', yrsel, '?')
  if(thrs)
    leglab <- paste0('Below\nthreshold\nin ', yrsel, '?')

  if(partialyr)
    leglab <- paste0(leglab, '*')

  # segment labels
  seglabs <- data.frame(
    Longitude = c(-82.6, -82.64, -82.58, -82.42),
    Latitude = c(27.55, 27.81, 28, 27.925),
    bay_segment = c('LTB', 'MTB', 'OTB', 'HB')
    ) %>%
    st_as_sf(coords = c('Longitude', 'Latitude'), crs = prj)

  transcol <- rgb(1, 1, 1, 0.5)

  # plot, this kills the message about coordinate systems
  suppressMessages({

    p <- ggmap::ggmap(bsmap) +
      geom_sf(data = tbseglines, colour = 'black', inherit.aes = F, size = 1) +
      ggrepel::geom_text_repel(data = tomap, aes(label = round(val, 1), geometry = geometry), stat = "sf_coordinates", size = 3, inherit.aes = F) +
      geom_sf(data = tomap, aes(colour = met, fill = met), colour = 'black', inherit.aes = F, size = 3, pch = 21) +
      geom_label(data = seglabs, aes(label = bay_segment, geometry = geometry), stat = "sf_coordinates", inherit.aes = F, fill = transcol) +
      scale_fill_manual(leglab,  values = c('green', 'red'), drop = F) +
      scale_colour_manual(leglab, values = c('green', 'red'), drop = F) +
      theme(
        axis.title = element_blank(),
        axis.text = element_text(size = 7),
        legend.position = c(0.8, 0.2),
        legend.background = element_blank()
      ) +
      guides(
        colour = guide_legend(override.aes = list(colour = c('green', 'red'))),
        fill = guide_legend(override.aes = list(colour = c('green', 'red')))
      ) +
      ggsn::scalebar(tbseg, dist = 6, dist_unit = "km", st.size = 3,
               transform = TRUE, model = "WGS84", height = 0.015)

    if(partialyr)
      p <- p +
        labs(caption = paste0('*Incomplete data for ', yrsel, ' estimated by five year average'))

  })

  suppressWarnings(print(p))

}

#' Map site and bay segment attainment categories for a selected year
#'
#' Map site and bay segment attainment categories for a selected year
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param yrsel numeric for year to plot
#' @param param chr string for which parameter to plot, one of \code{"chla"} for chlorophyll or \code{"la"} for light attenuation
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param thrs logical indicating if attainment category is relative to targets (default) or thresholds, passed to \code{\link{anlz_attainsite}}
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#' @param showseg logical indicating of bay segment labels are included
#' @param base_size numeric indicating text scaling size for plot
#' @param family optional chr string indicating font family for text labels
#'
#' @details The map is similar to that returned by \code{\link{show_sitemap}} with the addition of polygons for each bay segment colored by the annual attainment category and the site points are sized relative to the selected parameter in \code{param}.
#'
#' @concept show
#'
#' @return A static \code{ggplot} object is returned
#'
#' @export
#'
#' @import ggplot2 sf
#'
#' @examples
#' show_sitesegmap(epcdata, yrsel = 2025)
show_sitesegmap <- function(epcdata, yrsel, param = c('chla', 'la'), trgs = NULL, thrs = FALSE, partialyr = FALSE,
                            showseg = TRUE, base_size = 12, family = 'sans'){

  # sanity check
  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # parameter
  param <- match.arg(param)

  prj <- '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'

  # site
  avedatsite <- epcdata %>%
    anlz_avedatsite(partialyr = partialyr)

  ptcols <- c('yes' = '#2DC938', 'no' = '#CC3231')

    # segment
  avedat <- anlz_avedat(epcdata, partialyr = partialyr)
  if(!thrs){
    segcat <- anlz_attain(avedat, trgs = trgs) %>%
      dplyr::filter(yr == yrsel) %>%
      dplyr::mutate(
        outcome = factor(outcome,
                         levels = c('green', 'yellow', 'red'),
                         labels = c('Stay the Course', 'Caution', 'On Alert'))
      )
    segcols <- c('Stay the Course' = '#2DC938', 'Caution' = '#E9C318', 'On Alert' = '#CC3231')
  }
  if(thrs){
    segcat <- avedat %>%
      .$ann %>%
      dplyr::filter(yr == yrsel) %>%
      dplyr::filter(var %in% !!paste0('mean_', param)) %>%
      dplyr::left_join(trgs, by = 'bay_segment') %>%
      dplyr::select(bay_segment, yr, var, val, thresh = !!paste0(param, '_thresh')) %>%
      dplyr::mutate(
        bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB')),
        outcome = dplyr::case_when(
          val < thresh ~ 'Below',
          val >= thresh ~ 'Above'
        ),
        outcome = factor(outcome, levels = c('Below', 'Above'))
      )
    segcols <- c('Below' = '#2DC938', 'Above' = '#CC3231')
  }

  # final segment outcome as polygon
  segcat <- segcat %>%
    dplyr::select(bay_segment, outcome) %>%
    left_join(tbseg, ., by = 'bay_segment')

  # get site averages for selected year
  tomap <- avedatsite %>%
    anlz_attainsite(yrrng = yrsel, thr = param, trgs = trgs, thrs = thrs) %>%
    dplyr::mutate(
      met = factor(met, levels = c('yes', 'no'), labels = c('yes', 'no'))
    )

  # legend label
  leglab <- paste0('Target met in ', yrsel, '?')
  if(thrs)
    leglab <- gsub('^Target', 'Threshold', leglab)

  # legend label for point size
  leglabsz <- dplyr::case_when(
    param == 'chla' ~ "Annual mean Chl-a (ug/L)",
    param == 'la' ~ "Annual mean light att. (m-1)"
  )

  # add station lat/lon
  tomap <- tomap %>%
    dplyr::left_join(stations, by = c('epchc_station', 'bay_segment')) %>%
    st_as_sf(coords = c('Longitude', 'Latitude'), crs = prj)

  if(!requireNamespace('ggmap', quietly = TRUE))
    stop("Package \"ggmap\" needed for this function to work. Please install it.", call. = FALSE)

  if(!requireNamespace('ggspatial', quietly = TRUE))
    stop("Package \"ggspatial\" needed for this function to work. Please install it.", call. = FALSE)

  if(!requireNamespace('ggrepel', quietly = TRUE))
    stop("Package \"ggrepel\" needed for this function to work. Please install it.", call. = FALSE)

  if(!requireNamespace('ggnewscale', quietly = TRUE))
    stop("Package \"ggnewscale\" needed for this function to work. Please install it.", call. = FALSE)

  p <- ggmap::ggmap(bsmap) +
    geom_sf(data = segcat, aes(fill = outcome), colour = 'black', alpha = 0.5, inherit.aes = F) +
    ggplot2::scale_fill_manual(values = segcols, drop = T) +
    ggspatial::annotation_scale(unit_category = 'metric', location = 'br') +
    labs(fill = 'Bay segment outcomes')

  # plot, this kills the message about coordinate systems
  suppressMessages({

    p <- p +
      ggnewscale::new_scale_fill() +
      geom_sf(data = tomap, aes(colour = met, fill = met, size = val), colour = 'black', inherit.aes = F, pch = 21) +
      scale_fill_manual(leglab, values = ptcols, drop = F) +
      theme_bw(base_family = family, base_size = base_size) +
      theme(
        axis.title = element_blank(),
        axis.text = element_text(size = 7),
        legend.background = element_blank(),
        legend.key = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1),
        text = ggplot2::element_text(family = family)
      ) +
      labs(
        size = leglabsz
      ) +
      guides(
        fill = guide_legend(override.aes = list(colour = ptcols, size = 3))
      )

  })

  if(partialyr){

    p <- p +
      labs(caption = paste0('*Incomplete data for ', yrsel, ' estimated by five year average'))

  }

  # add bay segment labels
  if(showseg){

    transcol <- rgb(1, 1, 1, 0.5)

    # segment labels
    seglabs <- data.frame(
      Longitude = c(-82.6, -82.64, -82.58, -82.42),
      Latitude = c(27.55, 27.81, 28, 27.925),
      bay_segment = c('LTB', 'MTB', 'OTB', 'HB')
    ) %>%
      st_as_sf(coords = c('Longitude', 'Latitude'), crs = prj)

    p <- p +
      geom_label(data = seglabs, aes(label = bay_segment, geometry = geometry), stat = "sf_coordinates", inherit.aes = F, fill = transcol)

  }

  suppressWarnings(print(p))

}

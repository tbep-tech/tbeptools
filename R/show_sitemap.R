#' Map site attainment categories for a selected year
#'
#' Map site attainment categories for a selected year
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param yrsel numeric for year to plot
#' @param mosel optional numeric of length one or two for mapping results for a specific month or month range in a given year, default full year
#' @param param chr string for which parameter to plot, one of \code{"chla"} for chlorophyll or \code{"la"} for light attenuation
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}, only applies if \code{mosel = c(1, 12)}
#' @param thrs logical indicating if attainment category is relative to targets (default) or thresholds, passed to \code{\link{anlz_attainsite}}, only applies if \code{mosel = c(1, 12)}
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter, only applies if \code{mosel = c(1, 12)}
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
show_sitemap <- function(epcdata, yrsel, mosel = c(1, 12), param = c('chla', 'la'), trgs = NULL, thrs = FALSE, partialyr = FALSE){

  # sanity check
  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # correct month entry
  if(any(!mosel %in% 1:12))
    stop('mosel not in range of 1 to 12')
  if(length(mosel) == 2)
    if(mosel[2] < mosel[1])
      stop('mosel must be in ascending order')
  if(length(mosel) > 2 )
    stop('mosel must be length 1 or 2')

  # parameter
  param <- match.arg(param)

  # logical if full year
  fullyr <- sum(c(1, 12) %in% mosel) == 2

  prj <- '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'

  tomap <- epcdata %>%
    anlz_avedatsite(partialyr = partialyr)

  # get site averages for selected year
  if(fullyr){

    tomap <- tomap %>%
      anlz_attainsite(yrrng = yrsel, thr = param, trgs = trgs, thrs = thrs) %>%
      dplyr::mutate(
        met = factor(met, levels = c('yes', 'no'), labels = c('yes', 'no'))
      )

    # legend label
    leglab <- paste0('Target met\nin ', yrsel, '?')
    if(thrs)
      leglab <- paste0('Below\nthreshold\nin ', yrsel, '?')

  }

  # get monthly average range if not complete year
  if(!fullyr){

    mos <- mosel
    if(length(mosel) == 2)
      mos <- seq(mosel[1], mosel[2])

    # tomap
    tomap <- tomap[['mos']] %>%
      dplyr::filter(yr %in% yrsel) %>%
      dplyr::filter(mo %in% !!mos) %>%
      dplyr::filter(grepl(paste0('_', param, '$'), var)) %>%
      dplyr::group_by(bay_segment, epchc_station, yr) %>%
      dplyr::summarize(val = mean(val, na.rm = TRUE), .groups = 'drop')

    molabs <- paste(month.abb[mosel], collapse = '-')

    # legend label
    leglab <- dplyr::case_when(
        param == 'chla' ~ expression("Chl-a ("~mu * "g\u00B7L"^-1 *")"),
        param == 'la' ~ expression("Light Att. (m" ^-1 *")")
      )

  }

  # add station lat/lon
  tomap <- tomap %>%
    dplyr::left_join(stations, by = c('epchc_station', 'bay_segment')) %>%
    st_as_sf(coords = c('Longitude', 'Latitude'), crs = prj)

  # segment labels
  seglabs <- data.frame(
    Longitude = c(-82.6, -82.64, -82.58, -82.42),
    Latitude = c(27.55, 27.81, 28, 27.925),
    bay_segment = c('LTB', 'MTB', 'OTB', 'HB')
    ) %>%
    st_as_sf(coords = c('Longitude', 'Latitude'), crs = prj)

  transcol <- rgb(1, 1, 1, 0.5)

  p <- ggmap::ggmap(bsmap) +
    geom_sf(data = tbseglines, colour = 'black', inherit.aes = F, size = 1) +
    ggrepel::geom_text_repel(data = tomap, aes(label = round(val, 1), geometry = geometry), stat = "sf_coordinates", size = 3, inherit.aes = F) +
    geom_label(data = seglabs, aes(label = bay_segment, geometry = geometry), stat = "sf_coordinates", inherit.aes = F, fill = transcol) +
    ggsn::scalebar(tbseg, dist = 6, dist_unit = "km", st.size = 3,
                   transform = TRUE, model = "WGS84", height = 0.015)

  if(fullyr){

    # plot, this kills the message about coordinate systems
    suppressMessages({

      p <- p +
        geom_sf(data = tomap, aes(colour = met, fill = met), colour = 'black', inherit.aes = F, size = 3, pch = 21) +
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
        )

    })

    if(partialyr){

      leglab <- paste0(leglab, '*')
      p <- p +
        labs(caption = paste0('*Incomplete data for ', yrsel, ' estimated by five year average'))

    }

  }

  if(!fullyr){

    # plot, this kills the message about coordinate systems
    suppressMessages({

      p <- p +
        geom_sf(data = tomap, aes(fill = val), colour = 'black', inherit.aes = F, size = 3, pch = 21) +
        scale_fill_gradient(leglab, low = 'green', high = 'red') +
        theme(
          axis.title = element_blank(),
          axis.text = element_text(size = 7),
          legend.background = element_blank()
        ) +
        labs(subtitle = paste(molabs, yrsel))

    })

  }

  suppressWarnings(print(p))

}

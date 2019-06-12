#' @include class-epcdata.R
NULL

#' @rdname epcdata-class
setMethod('show',
          signature = 'epcdata',
          definition = function(object){

            # defined methods from below
            meths <- .S4methods(class = 'epcdata')
            meths <-  attr(meths, 'info')$generic
            meths <- meths[!meths %in% 'show']

            # number of records in data
            nobs <- nrow(rawdat(object))

            # on screen
            cat('An object of class', class(object), '\n')
            cat(nobs, 'records in imported data\n')
            cat('Methods that can be used with this object:', paste(meths, collapse = ', '), '\n')
            cat('Use methods as a function or slot, e.g., frmdat(epcdata) or epcdata@frmdat\n')
            cat('View help files for more info, e.g., ?frmdat\n')
            invisible(NULL)

          })

#' @param object \code{epcdata} object created with \code{\link{load_epchc_wq}}
#' @rdname epcdata-class
#'
#' @export
setGeneric('rawdat', function(object) standardGeneric('rawdat'))

#' @rdname epcdata-class
setMethod('rawdat', 'epcdata', function(object) object@rawdat)

#' @rdname epcdata-class
#' @export
setGeneric('frmdat', function(object) standardGeneric('frmdat'))

#' @rdname epcdata-class
setMethod('frmdat', 'epcdata', function(object) object@frmdat)

#' @rdname epcdata-class
#' @export
setGeneric('avedat', function(object) standardGeneric('avedat'))

#' @rdname epcdata-class
setMethod('avedat', 'epcdata', function(object) object@avedat)

#' @title Plot annual water quality values and thresholds for a segment
#'
#' @description Plot annual water quality values and thresholds for a bay segment
#'
#' @param object \code{\link{epcdata}} object
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
#' @param thr chr string indicating with water quality value and appropriate threshold to to plot, one of "chl" for chlorophyll and "la" for light availability
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
#' thrplot(epcdata, bay_segment = 'OTB', thr = 'chl')
#' }
setGeneric('thrplot', function(object, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), thr = c('chl', 'la')) standardGeneric('thrplot'))

#' @rdname thrplot
setMethod('thrplot', 'epcdata', function(object, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), thr = c('chla', 'la')){

  # segment
  bay_segment <- match.arg(bay_segment)

  # wq to plot
  thr <- match.arg(thr)

  # colors
  cols <- c("Annual Mean"="red", "Management Target"="blue", "Regulatory Threshold"="blue", "Small Mag. Exceedance"="blue", "Large Mag. Exceedance"="blue")

  # averages
  aves <- avedat(object)

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

})

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

            # # unique samples
            # n <- scores(object)
            # n <- unique(n$SampleID)
            # n <- length(n)

            # on screen
            cat('An object of class', class(object), '\n')
            # cat('Scores calculated for', paste(object@taxa, collapse = ', ') , 'indices for', n, 'unique samples\n')
            cat('Use these functions for access:', paste(meths, collapse = ', '), '\n')
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

#' @title Plot annual chlorophyll for a segment
#'
#' @description Plot chlorophyll annual values by standard for a bay segment
#'
#' @param object \code{\link{epcdata}} object
#' @param bay_segment chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"
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
#' chlplot(epcdata, bay_segment = 'OTB')
#' }
setGeneric('chlplot', function(object, bay_segment = c('OTB', 'HB', 'MTB', 'LTB')) standardGeneric('chlplot'))

#' @rdname chlplot
setMethod('chlplot', 'epcdata', function(object, bay_segment = c('OTB', 'HB', 'MTB', 'LTB')){

  # segment
  bay_segment <- match.arg(bay_segment)

  # averages
  aves <- avedat(object)

  # get chl data
  chladata <- aves$ann %>%
    dplyr::filter(grepl('chla', var)) %>%
    tidyr::spread(var, val)

  cols <- c("Annual Mean"="red", "Management Target"="blue", "Regulatory Threshold"="blue", "Small Mag. Exceedance"="blue", "Large Mag. Exceedance"="blue")

  # bay segment plot title
  ttl <- targets %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(name)

  # chlorophyll thresh
  chlthrs <- targets %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::pull(chla_thresh)

  p <- chladata %>%
    filter(bay_segment == !!bay_segment & yr < 2019) %>%
    ggplot(aes(x = yr)) +
    geom_point(aes(y = mean_chla, colour = "Annual Mean"), size = 3) +
    geom_line(aes(y = mean_chla, colour = "Annual Mean"), size = 0.75) +
    geom_hline(data = targets, aes(yintercept = chlthrs, colour = "Regulatory Threshold")) +
    ggtitle(ttl) +
    geom_text(data = targets, parse = TRUE,
              aes(1973, chlthrs,
                  label = paste(chlthrs,"~ mu * g%.%L^{-1}"),
                  hjust = 0.2, vjust = -0.3)) +
    ylab(expression("Mean Annual Chlorophyll-a ("~ mu * "g\u00B7L"^-1 *")")) +
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

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

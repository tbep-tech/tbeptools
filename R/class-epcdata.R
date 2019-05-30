#' @title An S4 class to represent an \code{epcdata} object
#'
#' @description The S4 \code{epcdata} object includes several methods shown below.
#'
#' @slot rawdat \code{data.frame} of raw imported EPCHC data
#' @slot frmdat \code{data.frame} of lightly formatted EPCHC data for secchi and chlorophyll data
#' @slot avedat \code{list} of annual (\code{ann}) and monthly (\code{mos}) segment means for secchi, light attenuation, and chlorophyll data
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- 'C:/Users/Owner/Desktop/2018_Results_Updated.xls'
#'
#' # load and assign to object
#' epcdata <- load_epchc_wq(xlsx)
#'
#' rawdat(epcdata)
#' frmdat(epcdata)
#' avedat(epcdata)
#' }
epcdata <- setClass('epcdata',
                 slots = list(
                   rawdat = 'data.frame',
                   frmdat = 'data.frame',
                   avedat = 'list'
                 )
)

#' Load local water quality file
#'
#' @param xlsx chr string path for local excel file, to overwrite it not current
#' @param na chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}
#' @param download_latest_epchc logical passed to \link{get_epchc_wq} to download raw data and compare with existing in \code{xlsx} if available
#' @param ... additional arguments passed to \code{\link[readxl]{read_xlsx}}
#'
#' @return A \code{\link{epcdata}} object with specific methods.  See the examples for accessing.
#'
#' @details Loads the "RWMDataSpreadsheet" worksheet from the file located at \code{xlsx}
#' @export
#'
#' @seealso \code{\link{form_epchc_wq}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- 'C:/Users/Owner/Desktop/2018_Results_Updated.xls'
#'
#' # load and assign to object
#' epcdata <- load_epchc_wq(xlsx)
#'
#' ##
#' # access data
#'
#' # raw
#' rawdat(epcdata)
#'
#' # formatted
#' frmdat(epcdata)
#'
#' # averages
#' avedat(epcdata)
#' }
load_epchc_wq <- function(xlsx, na = '', download_latest_epchc = FALSE, ...){

  # download latest and compare with current if exists
  get_epchc_wq(xlsx, download_latest_epchc)

  # sanity checks
  if(!download_latest_epchc)
    stopifnot(file.exists(xlsx))

  # load
  rawdat <- readxl::read_xlsx(xlsx, sheet="RWMDataSpreadsheet",
                       col_types = c("numeric", "numeric", "text", "text", "text", "text",
                                     "numeric", "numeric", "text", "numeric", "numeric",
                                     "text", "date", "text", "numeric", "text", "text",
                                     "numeric", "numeric", "numeric", "numeric", "text",
                                     "text", "text", "numeric", "text", "numeric", "text",
                                     "numeric", "text", "numeric", "text", "numeric",
                                     "text", "numeric", "text", "numeric", "text",
                                     "numeric", "text", "numeric", "text", "numeric",
                                     "text", "numeric", "text", "numeric", "text",
                                     "numeric", "text", "numeric", "text", "numeric",
                                     "text", "numeric", "text", "numeric", "text",
                                     "numeric", "text", "numeric", "text", "numeric",
                                     "text", "numeric", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text", "text", "text", "text",
                                     "text", "text", "text"),
                       na = '')

  # format names
  names(rawdat) <- gsub('\\r\\n', '_', names(rawdat))
  names(rawdat) <- gsub('/l$|/L$', 'L', names(rawdat))
  names(rawdat) <- gsub('/cm$', 'cm', names(rawdat))
  names(rawdat) <- gsub('/', '-', names(rawdat))
  names(rawdat) <- gsub('\\#\\-', 'num', names(rawdat))
  names(rawdat) <- gsub('\\(|\\)', '', names(rawdat))
  names(rawdat) <- gsub('\\%', 'pct', names(rawdat))
  names(rawdat) <- gsub('F\\s', '_F', names(rawdat))
  names(rawdat) <- gsub('C\\u', 'c\\u', names(rawdat))
  names(rawdat) <- gsub('^Nitrates$', 'Nitrates_mgL', names(rawdat))

  # format
  frmdat <- form_epchc_wq(rawdat)

  # get annual, monthly means
  avedat <- mean_epchc_wq(frmdat)

  ##
  # create epcdata class output
  out <- epcdata(rawdat = rawdat, frmdat = frmdat, avedat = avedat)

  return(out)

}

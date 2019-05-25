#' Load local water quality file
#'
#' @param xlsx chr string path for local excel file, to overwrite it not current
#' @param na chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}
#' @param download_latest_epchc logical passed to \link{get_epchc_wq} to download raw data and compare with existing in \code{xlsx} if available
#' @param ... additional arguments passed to \code{\link[readxl]{read_xlsx}}
#'
#' @return A formatted \code{data.frame} of water quality data
#'
#' @details Loads the "RWMDataSpreadsheet" worksheet from the file located at \code{xlsx}
#' @export
#'
#' @examples
#' \dontrun{
#' xlsx <- 'C:/Users/Owner/Desktop/2018_Results_Updated.xls'
#' epcdata <- load_epchc_wq(xlsx)
#' }
load_epchc_wq <- function(xlsx, na = '', download_latest_epchc = FALSE, ...){

  # download latest and compare with current if exists
  get_epchc_wq(xlsx, download_latest_epchc)

  # sanity checks
  if(!download_latest_epchc)
    stopifnot(file.exists(xlsx))

  # load
  dat <- readxl::read_xlsx(xlsx, sheet="RWMDataSpreadsheet",
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
  names(dat) <- gsub('\\r\\n', '_', names(dat))
  names(dat) <- gsub('/l$|/L$', 'L', names(dat))
  names(dat) <- gsub('/cm$', 'cm', names(dat))
  names(dat) <- gsub('/', '-', names(dat))
  names(dat) <- gsub('\\#\\-', 'num', names(dat))
  names(dat) <- gsub('\\(|\\)', '', names(dat))
  names(dat) <- gsub('\\%', 'pct', names(dat))
  names(dat) <- gsub('F\\s', '_F', names(dat))
  names(dat) <- gsub('C\\u', 'c\\u', names(dat))
  names(dat) <- gsub('^Nitrates$', 'Nitrates_mgL', names(dat))

  return(dat)

}

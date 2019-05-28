#' Load local water quality file
#'
#' @param xlsx chr string path for local excel file, to overwrite it not current
#' @param na chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}
#' @param download_latest_epchc logical passed to \link{get_epchc_wq} to download raw data and compare with existing in \code{xlsx} if available
#' @param format logical if input file loaded from \code{xlsx} is formatted for chlorophyll and secchi data, uses \code{\link{form_epchc_wq}}
#' @param ... additional arguments passed to \code{\link[readxl]{read_xlsx}}
#'
#' @return A \code{data.frame} of water quality data, minimal formatting
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
#' }
load_epchc_wq <- function(xlsx, na = '', download_latest_epchc = FALSE, format = TRUE, ...){

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

  # format
  if(format)
    dat <- form_epchc_wq(dat)

  return(dat)

}

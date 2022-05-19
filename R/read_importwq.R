#' Load local water quality file
#'
#' @param xlsx chr string path for local excel file, to overwrite if not current
#' @param download_latest logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{xlsx} if available
#' @param na chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}
#'
#' @return A \code{data.frame} of formatted water quality data.
#'
#' @details Loads the "RWMDataSpreadsheet" worksheet from the file located at \code{xlsx}.  The file is downloaded from \url{https://epcbocc.sharepoint.com/:x:/s/Share/EWKgPirIkoxMp9Hm_wVEICsBk6avI9iSRjFiOxX58wXzIQ?e=kAWZXl&download=1}.
#' @export
#'
#' @concept read
#'
#' @seealso \code{\link{read_formwq}}, \code{\link{read_importphyto}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
#'
#' # load and assign to object
#' epcdata <- read_importwq(xlsx, download_latest = T)
#' }
read_importwq <- function(xlsx, download_latest = FALSE, na = ''){

  # download latest and compare with current if exists
  urlin <- 'https://epcbocc.sharepoint.com/:x:/s/Share/EWKgPirIkoxMp9Hm_wVEICsBk6avI9iSRjFiOxX58wXzIQ?e=kAWZXl&download=1'
  read_dlcurrent(xlsx, download_latest, urlin = urlin)

  # sanity checks
  if(!download_latest)
    stopifnot(file.exists(xlsx))

  # load
  rawdat <- suppressWarnings(readxl::read_xlsx(xlsx, sheet="RWMDataSpreadsheet",
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
                       na = na))

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
  out <- read_formwq(rawdat)

  return(out)

}

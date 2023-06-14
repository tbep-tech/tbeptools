#' Download and/or import local water quality file for internal use
#'
#' @param xlsx chr string path for local excel file, to overwrite if not current
#' @param download_latest logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{xlsx} if available
#' @param na chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}
#'
#' @return An unformatted \code{data.frame} from EPC
#'
#' @details Loads the "RWMDataSpreadsheet" worksheet from the file located at \code{xlsx}.  The file is downloaded from \url{https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1}.  The files can be viewed at \url{https://epcbocc.sharepoint.com/:f:/s/Share/EiypSSYdsEFCi84Sv_6-t7kBUYaXiIqN0B1n2w57Z_V3kQ?e=NdZQcU}.
#'
#' This function is used internally by \code{\link{read_importwq}} and \code{\link{read_importfib}} because both use the same source data from the Environmental Protection Commission of Hillsborough County.
#'
#' @export
#'
#' @concept read
#'
#' @seealso \code{\link{read_importwq}}, \code{\link{read_importfib}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
#'
#' # load and assign to object
#' epcall <- read_importepc(xlsx, download_latest = T)
#' }
read_importepc <- function(xlsx, download_latest = FALSE, na = ''){

  # download latest and compare with current if exists
  urlin <- 'https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1'
  read_dlcurrent(xlsx, download_latest, urlin = urlin)

  # sanity checks
  if(!download_latest)
    stopifnot(file.exists(xlsx))

  # load
  out <- suppressWarnings(readxl::read_xlsx(xlsx, sheet="RWMDataSpreadsheet",
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
  names(out) <- gsub('\\r\\n', '_', names(out))
  names(out) <- gsub('/l$|/L$', 'L', names(out))
  names(out) <- gsub('/cm$', 'cm', names(out))
  names(out) <- gsub('/', '-', names(out))
  names(out) <- gsub('\\#\\-', 'num', names(out))
  names(out) <- gsub('\\(|\\)', '', names(out))
  names(out) <- gsub('\\%', 'pct', names(out))
  names(out) <- gsub('F\\s', '_F', names(out))
  names(out) <- gsub('C\\u', 'c\\u', names(out))
  names(out) <- gsub('^Nitrates$', 'Nitrates_mgL', names(out))

  return(out)

}

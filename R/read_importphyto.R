#' Load local phytoplankton cell count file
#'
#' @param xlsx chr string path for local excel file, to overwrite if not current
#' @param download_latest logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{xlsx} if available
#' @param na chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}
#'
#' @return A \code{data.frame} of formatted water quality data.
#'
#' @details Pytoplankton cell count data downloaded from ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/, file PlanktonDataList_ThroughCurrentReportMonth.xlsx
#'
#' @export
#'
#' @family read
#'
#' @seealso \code{\link{read_importwq}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- 'C:/Users/Owner/Desktop/phyto_data.xlsx'
#'
#' # load and assign to object
#' phytodata <- read_importphyto(xlsx)
#' }
read_importphyto <- function(xlsx, download_latest = FALSE, na = ''){

  # download latest and compare with current if exists
  urlin <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/PlanktonDataList_ThroughCurrentReportMonth.xlsx"
  read_dlcurrent(xlsx, download_latest, urlin = urlin)

  # sanity checks
  if(!download_latest)
    stopifnot(file.exists(xlsx))

  # load
  rawdat <- readxl::read_xlsx(xlsx, na = na, col_types = c("text", "text", "text", "text", "text", "text", "date", "text",
                                                           "text", "text", "text", "text", "text", "text", "text", "text",
                                                           "text", "text", "text", "text", "text", "text", "text", "text",
                                                           "text", "text", "text")
  )

  # format
  out <- read_formphyto(rawdat)

  return(out)

}

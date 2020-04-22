#' Load local FIM data for the Tampa Bay Nekton Index
#'
#' @param csv chr string path for local csv file, to overwrite if not current
#' @param download_latest logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{csv} if available
#' @param connecttimeout numeric for maximum number of seconds to wait until connection timeout for \code{\link[RCurl]{getURL}}
#' @param tryurl logical indicating if \code{\link[RCurl]{getURL}} is repeatedly called in a \code{while} loop if first connection is unsuccessful
#'
#' @return A \code{data.frame} of formatted FIM data.
#'
#' @details Data downloaded from \url{'ftp://ftp.floridamarine.org/users/fim/tmac/NektonIndex/TampaBay_NektonIndexData_20200406.csv'}.
#' @export
#'
#' @family read
#'
#' @seealso \code{\link{read_formwq}}, \code{\link{read_importphyto}}
#'
#' @examples
#' \dontrun{
#' # file path
#' csv <- 'C:/Users/Owner/Desktop/fimraw.csv'
#'
#' # load and assign to object
#' fimdata <- read_importfim(csv)
#' }
read_importfim <- function(csv, download_latest = FALSE, connecttimeout = 10, tryurl = FALSE){

  # download latest and compare with current if exists
  urlin <- 'ftp://ftp.floridamarine.org/users/fim/tmac/NektonIndex/TampaBay_NektonIndexData_20200406.csv'
  read_dlcurrent(csv, download_latest, connecttimeout = connecttimeout, tryurl = tryurl, urlin = urlin)

  # sanity checks
  if(!download_latest)
    stopifnot(file.exists(csv))

  # load
  rawdat <- read.csv(csv, stringsAsFactors = F)

  # format
  # out <- read_formwq(rawdat)
  out <- rawdat

  return(out)

}

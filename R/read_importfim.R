#' Load local FIM data for the Tampa Bay Nekton Index
#'
#' @param csv chr string path for local csv file, to overwrite if not current
#' @param download_latest logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{csv} if available
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
read_importfim <- function(csv, download_latest = FALSE){

  # download latest and compare with current if exists
  urlin <- 'ftp://ftp.floridamarine.org/users/fim/tmac/NektonIndex/TampaBay_NektonIndexData.csv'
  read_dlcurrent(csv, download_latest, urlin = urlin)

  # sanity checks
  if(!download_latest)
    stopifnot(file.exists(csv))

  # load
  rawdat <- read.csv(csv, stringsAsFactors = F)

  # format
  out <- read_formfim(rawdat)

  return(out)

}

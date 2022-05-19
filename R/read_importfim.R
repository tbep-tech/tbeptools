#' Load local FIM data for the Tampa Bay Nekton Index
#'
#' @param csv chr string path for local csv file, to overwrite if not current
#' @param download_latest logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{csv} if available
#' @param locs logical indicating if a spatial features object is returned with locations of each FIM sampling station
#'
#' @return A formatted \code{data.frame} with FIM data if \code{locs = FALSE}, otherwise a simple features object if \code{locs = TRUE}
#'
#' @details Data downloaded from ftp://ftp.floridamarine.org/users/fim/tmac/NektonIndex/TampaBay_NektonIndexData.csv.
#' @export
#'
#' @concept read
#'
#' @seealso \code{\link{read_formwq}}, \code{\link{read_importphyto}}
#'
#' @examples
#' \dontrun{
#' # file path
#' csv <- '~/Desktop/fimraw.csv'
#'
#' # load and assign to object
#' fimdata <- read_importfim(csv, download_latest = TRUE)
#' }
read_importfim <- function(csv, download_latest = FALSE, locs = FALSE){

  # download latest and compare with current if exists
  urlin <- 'ftp://ftp.floridamarine.org/users/fim/tmac/NektonIndex/TampaBay_NektonIndexData.csv'
  read_dlcurrent(csv, download_latest, urlin = urlin)

  # sanity checks
  if(!download_latest)
    stopifnot(file.exists(csv))

  # load
  rawdat <- read.csv(csv, stringsAsFactors = F)

  # format
  out <- read_formfim(rawdat, locs = locs)

  return(out)

}

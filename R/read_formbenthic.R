#' Format benthic data for the Tampa Bay Benthic Index
#'
#' @param channel A \code{\link[RODBC]{RODBC}} class connection object to the .mdb benthic database
#'
#' @return A formatted \code{data.frame} of benthic and supporting data for the TBBI
#'
#' @details Function is used internally within \code{\link{read_importbenthic}}, see the help file for limitations on using the function outside of Windows.
#'
#' @family read
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(RODBC)
#'
#' # setup driver and path to .mdb
#' drvr <- 'Driver={Microsoft Access Driver (*.mdb, *.accdb)};'
#' path <- 'C:/Users/mbeck/Desktop/benthic/EPC DataSubmittals.mdb'
#' odbccall <- paste0(drvr, 'DBQ=', path)
#'
#' # create channel and pass to read_formbenthic
#' channel <- RODBC::odbcDriverConnect(odbccall)
#' read_formbenthic(channel)
#' }
read_formbenthic <- function(channel){

  # # show tables
  # sqlTables(channel)

  # fetch biology table
  out <- RODBC::sqlFetch(channel, "Biology")

  return(out)

}


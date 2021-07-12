#' FDEP IWR run 61
#'
#' Florida Department of Environmental Protection, Impaired Waters Rule, Run 61
#'
#' @details
#' This file was created by importing a SAS file directly into R using the \code{\link[haven]{read_sas}} function.  The SAS file is prepared annually by FDEP for Janicki Environmental, Inc.
#'
#' @format A data frame 1338532 rows and 15 variables
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' library(haven)
#'
#' iwrraw <- read_sas('../../02_DOCUMENTS/tidal_creeks/iwrraw_creeks61.sas7bdat')
#' iwrraw <- zap_formats(iwrraw)
#' save(iwrraw, file = 'data/iwrraw.RData', compress = 'xz')
#'
#' }
"iwrraw"

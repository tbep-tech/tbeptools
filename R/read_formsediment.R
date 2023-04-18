#' Format sediment data
#'
#' @param pathin A path to unzipped csv files with sediment result tables
#'
#' @return A \code{data.frame} of sediment data for Tampa Bay
#'
#' @details Function is used internally within \code{\link{read_importsediment}}
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # location to download data
#' path <- '~/Desktop/sediment.zip'
#'
#' # download
#' urlin1 <- 'https://epcbocc.sharepoint.com/:x:/s/Share/'
#' urlin2 <- 'Ef9utuKCHD9LliarsOPKCJwB5kxgCObf0tY5x5wX20JQUA?e=DuTseb'
#' urlin <- paste0(urlin1, urlin2, '&download=1')
#' read_dlcurrent(path, download_latest = TRUE, urlin = urlin)
#'
#' # unzip
#' tmppth <- tempfile()
#' utils::unzip(path, exdir = tmppth, overwrite = TRUE)
#'
#' # format sediment data
#' read_formsediment(pathin = tmppth)
#'
#' # remove temporary path
#' unlink(tmppth, recursive = TRUE)
#'
#' }
read_formsediment <- function(pathin){

  tzone <- 'America/Jamaica'

  # fetch relevant tables ---------------------------------------------------

  # files
  fls <- list.files(pathin, recursive = T, full.names = T)

  # sediment chemistry list
  SedimentChemistryList <- read.csv(grep('/SedimentChemistryList\\.csv$', fls, value = TRUE))

  # format for output -------------------------------------------------------

  out <- SedimentChemistryList %>%
    dplyr::select(-DataSource, -LabIdNumber, -AreaName, -Hexagon, -AnalysisTypeAbbr,
                  -ParameterID, -ValueText, -ValueNum, -ResultComments, -MDLCode,
                  -MDLText, -PQLText, -PrepMethod, -MethodTypeAbbr, -LaboratoryAbbr,
                  -CASNumber, -NELACNumber, -DOHCertification, -WQMQCSignOff) %>%
    dplyr::rename(yr = Year) %>%
    dplyr::mutate(
      PEL = ifelse(Parameter == 'DDE', 374, PEL), # see dk email 1/11/2023, should not be 37.4
      FundingProject = gsub('\\s+$', '', FundingProject),
      Replicate = tolower(Replicate),
      Units = gsub('Kg$', 'kg', Units),
      BetweenTELPEL = ifelse(`ValueAdjusted` > TEL & `ValueAdjusted` <= PEL & !grepl('U|T', Qualifier), 'Yes', 'No'),
      ExceedsPEL = ifelse(`ValueAdjusted` > PEL & !grepl('U|T', Qualifier), 'Yes', 'No'),
      PELRatio = `ValueAdjusted` / PEL
    ) %>%
    tibble::tibble()

  return(out)

}


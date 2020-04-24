#' Format FIM data for the Tampa Bay Nekton Index
#'
#' @param datin input \code{data.frame} loaded from \code{\link{read_importfim}}
#'
#' @return A formatted \code{data.frame} with chloropyll and secchi observations
#' @export
#'
#' @family read
#'
#' @importFrom magrittr %>%
#'
#' @details Function is used internally within \code{\link{read_importfim}}
#'
#' @seealso \code{\link{read_importfim}}
#'
#' @examples
#' \dontrun{
#' # file path
#' csv <- 'C:/Users/Owner/Desktop/fimraw.csv'
#'
#' # load and assign to object
#' fimdata <- read_importfim(csv)
#' }
read_formfim <- function(datin){

  # join catch data with locations in fimstations, format
  frmdat <- datin %>%
    select(-matches('^Project'), -Latitude, -Longitude, -Stratum, -effort, -Species_record_id, -Scientificname, -Commonname, -Cells) %>%
    dplyr::right_join(fimstations, by = c("Reference", "Zone", "Grid")) %>%
    dplyr::select(-geometry) %>%
    dplyr::mutate(
      NODCCODE = as.character(NODCCODE),
      NODCCODE = dplyr::case_when(
        NODCCODE == "9.998e+09" ~ "9998000000",
        NODCCODE == "9.999e+09" ~ "9999000000",
        TRUE ~ NODCCODE
        ),
      Sampling_Date = lubridate::ymd(Sampling_Date),
      Year = lubridate::year(Sampling_Date),
      Month = lubridate::month(Sampling_Date),
      Splittype = gsub('^\\s*\\.$', '', Splittype),
      Splittype = as.numeric(Splittype),
      Splitlevel = gsub('^\\s*\\.$', '', Splitlevel),
      Splitlevel = as.numeric(Splitlevel),
      Count = dplyr::case_when(
        !is.na(Splittype) ~ Number * Splittype ^ Splitlevel,
        TRUE ~ as.numeric(Number)
        )
      ) %>%
    dplyr::select(-Splittype, -Splitlevel) %>%
    dplyr::group_by(Reference, NODCCODE) %>%
    dplyr::mutate(Total_N = sum(Count)) %>%
    dplyr::select(-Count, -Number) %>%
    dplyr::distinct() %>%
    dplyr::filter(!NODCCODE == "9999000000")

  # join catch data with species classifications
  out <- frmdat %>%
    dplyr::left_join(tbnispp, by = "NODCCODE") %>%
    dplyr::filter(Include_TB_Index == "Y") %>%
    dplyr::arrange(Reference, NODCCODE) %>%
    dplyr::ungroup()

  return(out)

}


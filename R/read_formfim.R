#' Format FIM data for the Tampa Bay Nekton Index
#'
#' @param datin input \code{data.frame} loaded from \code{\link{read_importfim}}
#' @param locs logical indicating if a spatial features object is returned with locations of each FIM sampling station
#'
#' @return A formatted \code{data.frame} with FIM data if \code{locs = FALSE}, otherwise a simple features object if \code{locs = TRUE}
#' @export
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @details Function is used internally within \code{\link{read_importfim}}
#'
#' @seealso \code{\link{read_importfim}}
#'
#' @examples
#' # file path
#' url <- 'https://raw.githubusercontent.com/tbep-tech/tbni-proc/master/data/'
#' fl <- 'TampaBay_NektonIndexData.csv'
#' csv <- url(paste0(url, fl))
#'
#' datin <- read.csv(csv)
#'
#' # load and assign to object
#' fimdata <- read_formfim(datin)
read_formfim <- function(datin, locs = FALSE){

  # make data sf to get bay segments
  frmdat <- datin %>%
    dplyr::select(-matches('^Project'), -Stratum, -effort, -Species_record_id, -Scientificname, -Commonname, -Cells)

  # get bay segments
  majshed <- tbsegshed %>%
    dplyr::filter(bay_segment %in% c('OTB', 'HB', 'MTB', 'LTB')) %>%
    dplyr::select(bay_segment)

  frmdatloc <- datin %>%
    dplyr::select(Reference, Grid, Longitude, Latitude) %>%
    unique %>%
    sf::st_as_sf(
      coords = c("Longitude", "Latitude"),
      agr = "constant",
      crs = 4326,
      stringsAsFactors = FALSE,
      remove = TRUE
    ) %>%
    sf::st_intersection(., st_make_valid(majshed)) %>%
    dplyr::mutate(
      bay_segment = dplyr::case_when(
        Grid == 363 ~ "LTB",
        Grid %in% c(203, 220) ~ "MTB",
        (Grid == 204 & unlist(purrr::map(.$geometry,1)) < 27.7937) ~ "MTB",
        TRUE ~ bay_segment)
      ) %>%
    dplyr::select(-Grid)

  if(locs)
    return(frmdatloc)

  frmdat <- frmdat %>%
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
    dplyr::group_by(Reference, NODCCODE, Longitude, Latitude) %>%
    dplyr::mutate(Total_N = sum(Count)) %>%
    dplyr::select(-Count, -Number) %>%
    dplyr::distinct() %>%
    dplyr::filter(!NODCCODE == "9999000000")

  # join catch data with species classifications
  out <- frmdat %>%
    dplyr::left_join(tbnispp, by = "NODCCODE") %>%
    dplyr::select(-TSN) %>%
    dplyr::filter(Include_TB_Index == "Y") %>%
    dplyr::arrange(Reference, NODCCODE) %>%
    dplyr::ungroup() %>%
    inner_join(frmdatloc, by = 'Reference') %>%
    select(-geometry)

  return(out)

}


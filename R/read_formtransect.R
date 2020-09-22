#' Format seagrass transect data from Water Atlas
#'
#' @param jsn A data frame returned from \code{\link[jsonlite]{fromJSON}}
#' @param training logical if input are transect training data or complete database
#'
#' @return data frame in long format
#' @export
#' @details
#' Shoot density is reported as number of shoots per square meter and is corrected for the quadrat size entered in the raw data.  Shoot density and blade height are based on averages across random observations at each transect point that are entered separately in the data form.
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' library(jsonlite)
#'
#' \dontrun{
#' # all transect data
#' url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/all__use-with-care'
#' jsn <- fromJSON(url)
#' trndat <- read_formtransect(jsn)
#' }
#'
#' # training transect data
#' url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/training'
#' jsn <- fromJSON(url)
#' trndat <- read_formtransect(jsn, training = TRUE)
read_formtransect <- function(jsn, training = FALSE){

  if(training)
    out <- jsn %>%
      tibble::as_tibble() %>%
      dplyr::rename(IDall = ID) %>%
      tidyr::unnest('Observation') %>%
      dplyr::select(Crew, MonitoringAgency, Site, Depth, Savspecies = Species, Abundance = SpeciesAbundance,
                    matches('BladeLength_|ShootDensity_')) %>%
      dplyr::select(-BladeLength_Avg, -BladeLength_StdDev, -ShootDensity_Avg, -ShootDensity_StdDev) %>%
      dplyr::mutate(
        Abundance = gsub('\\s=.*$', '', Abundance),
        Abundance = dplyr::case_when(
          grepl('[a-z,A-Z]', Abundance) ~ NA_character_,
          T ~ Abundance
        ),
        Abundance = as.numeric(Abundance)
      ) %>%
      tidyr::gather('var', 'val', -Crew, -MonitoringAgency, -Site, -Depth, -Savspecies) %>%
      dplyr::mutate(
        rep = gsub('.*([0-9])$', '\\1', var),
        rep = gsub('^Abundance$', '1', rep),
        var = gsub('[0-9]$', '', var),
        var = dplyr::case_when(
          var == 'BladeLength_' ~ 'Blade Length',
          var == 'ShootDensity_' ~ 'Short Shoot Density',
          T ~ var
        ),
        val = gsub("[^0-9.-]", '', val),
        val = as.numeric(val),
        Site = as.character(Site)
      ) %>%
      dplyr::group_by(Crew, MonitoringAgency, Site, Depth, Savspecies, var) %>%
      dplyr::summarise(
        aveval = mean(val, na.rm = T),
        sdval = sd(val, na.rm = T)
      ) %>%
      dplyr::ungroup() %>%
      dplyr::filter(Savspecies %in% c('Halodule', 'Halophila', 'Ruppia', 'Syringodium', 'Thalassia'))

  if(!training)
    out <- jsn %>%
      tibble::as_tibble() %>%
      dplyr::rename(IDall = ID) %>%
      tidyr::unnest('Observation') %>%
      dplyr::select(Crew, MonitoringAgency, Date = ObservationDate, Transect, Site, Depth, Savspecies = Species, SeagrassEdge, Abundance = SpeciesAbundance,
                    matches('BladeLength_|ShootDensity_|CountSqSize_')) %>%
      dplyr::select(-BladeLength_Avg, -BladeLength_StdDev, -ShootDensity_Avg, -ShootDensity_StdDev) %>%
      dplyr::mutate(
        Abundance = gsub('\\s=.*$', '', Abundance),
        Abundance = dplyr::case_when(
          grepl('[a-z,A-Z]', Abundance) ~ NA_character_,
          T ~ Abundance
        ),
        Abundance = as.numeric(Abundance),
        Date = gsub('T', '', Date),
        Date = lubridate::ymd_hms(Date),
        Date = lubridate::date(Date),
        ShootDensity_1 = dplyr::case_when(
          !is.na(CountSqSize_1) & CountSqSize_1 > 0 ~ 1e5* ShootDensity_1 / (CountSqSize_1^2)
          ),
        ShootDensity_2 = dplyr::case_when(
          !is.na(CountSqSize_2) & CountSqSize_2 > 0 ~ 1e5 * ShootDensity_2 / (CountSqSize_2^2)
          ),
        ShootDensity_3 = dplyr::case_when(
          !is.na(CountSqSize_3) & CountSqSize_3 > 0 ~ 1e5* ShootDensity_3 / (CountSqSize_3^2)
          )
        ) %>%
      dplyr::select(-matches('CountSqSize_')) %>%
      tidyr::gather('var', 'val', -Crew, -Date, -MonitoringAgency, -Transect, -Site, -Depth, -Savspecies, -SeagrassEdge) %>%
      dplyr::mutate(
        rep = gsub('.*([0-9])$', '\\1', var),
        rep = gsub('^Abundance$', '1', rep),
        var = gsub('[0-9]$', '', var),
        var = dplyr::case_when(
          var == 'BladeLength_' ~ 'Blade Length',
          var == 'ShootDensity_' ~ 'Short Shoot Density',
          T ~ var
        ),
        val = gsub("[^0-9.-]", '', val),
        val = as.numeric(val),
        Site = as.character(Site)
      ) %>%
      dplyr::group_by(Crew, MonitoringAgency, Date, Transect, Site, Depth, Savspecies, SeagrassEdge, var) %>%
      dplyr::summarise(
        aveval = mean(val, na.rm = T),
        sdval = sd(val, na.rm = T)
      ) %>%
      dplyr::ungroup()

  return(out)

}
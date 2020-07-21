#' Format transect data from Water Atlas
#'
#' @param trnjsn output from \code{\link{read_trnjsn}}
#' @param training logical if input are transect training data or complete database
#'
#' @return data frame in long format
#' @export
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' trnjsn <- read_trnjsn(training = TRUE)
#' anlz_trnjsn(trnjsn, training = TRUE)
anlz_trnjsn <- function(trnjsn, training = FALSE){

  if(training)
    out <- trnjsn %>%
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
    out <- trnjsn %>%
      tibble::as_tibble() %>%
      dplyr::rename(IDall = ID) %>%
      tidyr::unnest('Observation') %>%
      dplyr::select(Crew, MonitoringAgency, Date = ObservationDate, Transect, Site, Depth, Savspecies = Species, Abundance = SpeciesAbundance,
                    matches('BladeLength_|ShootDensity_')) %>%
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
        Date = lubridate::date(Date)
      ) %>%
      tidyr::gather('var', 'val', -Crew, -Date, -MonitoringAgency, -Transect, -Site, -Depth, -Savspecies) %>%
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
      dplyr::group_by(Crew, MonitoringAgency, Date, Transect, Site, Depth, Savspecies, var) %>%
      dplyr::summarise(
        aveval = mean(val, na.rm = T),
        sdval = sd(val, na.rm = T)
      ) %>%
      dplyr::ungroup()

  return(out)

}

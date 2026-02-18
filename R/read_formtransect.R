#' Format seagrass transect data from Water Atlas
#'
#' @param jsn A data frame returned from \code{\link[jsonlite]{fromJSON}}
#' @param training logical if input are transect training data or complete database
#' @param raw logical indicating if raw, unformatted data are returned, see details
#'
#' @return data frame in long format
#' @export
#' @details
#' Shoot density is reported as number of shoots per square meter and is corrected for the quadrat size entered in the raw data.  Shoot density and blade height (cm) are based on averages across random observations at each transect point that are entered separately in the data form. Abundance is reported as a numeric value from 0 - 5 for Braun-Blanquet coverage estimates.
#'
#' If \code{raw = TRUE}, the unformatted data are returned.  The default is to use formatting that allows the raw data to be used with the downstream functions. The raw data may have extra information that may be of use outside of the plotting functions in this package.
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' library(jsonlite)
#'
#' \dontrun{
#' # all transect data
#' url <- 'https://tampabay.wateratlas.usf.edu/seagrass-transect-data-portal/api/assessments/all__use-with-care'
#' jsn <- fromJSON(url)
#' trndat <- read_formtransect(jsn)
#' }
#'
#' # training transect data
#' url <- 'https://tampabay.wateratlas.usf.edu/seagrass-transect-data-portal/api/assessments/training'
#' jsn <- fromJSON(url)
#' trndat <- read_formtransect(jsn, training = TRUE)
read_formtransect <- function(jsn, training = FALSE, raw = FALSE){

  if(training){

    out <- jsn %>%
      tibble::as_tibble() %>%
      dplyr::rename(IDall = ID) %>%
      tidyr::unnest('Observation')

    if(raw)
      return(out)

    out <- out %>%
      dplyr::select(yr = AssessmentYear, Crew, MonitoringAgency, Site, Depth, Species, Abundance = SpeciesAbundance,
                    matches('BladeLength_|ShootDensity_')) %>%
      dplyr::select(-BladeLength_Avg, -BladeLength_StdDev, -ShootDensity_Avg, -ShootDensity_StdDev) %>%
      dplyr::mutate(
        Abundance = gsub('\\s=.*$', '', Abundance),
        Abundance = dplyr::case_when(
          grepl('[a-z,A-Z]', Abundance) ~ NA_character_,
          T ~ Abundance
        ),
        Abundance = as.numeric(Abundance),
        Species = gsub('\\r\\n', '', Species)
      ) %>%
      tidyr::gather('var', 'val', -yr, -Crew, -MonitoringAgency, -Site, -Depth, -Species) %>%
      dplyr::group_by(yr) %>%
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
        Site = as.character(Site),
        grpact = paste0(yr, ': ', MonitoringAgency, ' (', Crew, ')')
      ) %>%
      dplyr::ungroup() %>%
      dplyr::group_by(yr) %>%
      dplyr::mutate(
        grp = factor(grpact, levels = unique(sort(grpact)), labels = toupper(letters[1:length(unique(grpact))])),
        grp = as.character(grp)
      ) %>%
      dplyr::ungroup() %>%
      dplyr::group_by(yr, grp, grpact, Crew, MonitoringAgency, Site, Depth, Species, var) %>%
      dplyr::summarise(
        aveval = mean(val, na.rm = T),
        sdval = sd(val, na.rm = T)
      ) %>%
      dplyr::ungroup()

    }

  if(!training){
    out <- jsn %>%
      tibble::as_tibble() %>%
      dplyr::rename(IDall = ID) %>%
      tidyr::unnest('Observation')

    if(raw)
      return(out)

    out <- out %>%
      dplyr::select(IDall, Crew, MonitoringAgency, Date = ObservationDate, Transect, Site, Depth, Savspecies = Species, SeagrassEdge, Abundance = SpeciesAbundance,
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
      dplyr::mutate(
        Date = max(Date), # IDall is unique ID for eacah transect sample, some are sampled on more than one day, using date as a unique id screws it up
        .by = c(IDall)
      ) %>%
      dplyr::select(-IDall) %>%
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
        Site = as.character(Site),
        Savspecies = gsub('^Halophila\\sspp\\.$', 'Halophila', Savspecies)
      ) %>%
      dplyr::group_by(Crew, MonitoringAgency, Date, Transect, Site, Depth, Savspecies, SeagrassEdge, var) %>%
      dplyr::summarise(
        aveval = mean(val, na.rm = T),
        sdval = sd(val, na.rm = T)
      ) %>%
      dplyr::ungroup()

    # fix abundance values to those only in BB estimates
    est <- c(0, 0.1, 0.5, 1, 2, 3, 4, 5)
    sub <- out$var == 'Abundance'
    out[sub, 'aveval'] <- sapply(out[sub, 'aveval', drop = T], function(x) ifelse(is.na(x), NA, est[which.min(abs(x - est))]))

  }

  return(out)

}

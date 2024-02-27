#' Estimate hydrological estimates and adjustment factors for bay segments
#'
#' Estimate hydrological estimates and adjustment factors for bay segments
#'
#' @param yrs numeric vector indicating years to return
#' @param noaa_key user-supplied NOAA key, see details
#' @param trace logical indicating if function progress is printed in the consol
#'
#' @details
#' This function uses rainfall and streamflow data from NOAA and USGS and requires an API key.  See the "Authentication" section under the help file for ncdc in the defunct rnoaa package.  This key can be added to the R environment file and called for later use, see the examples.
#'
#' These estimates are used in annual compliance assessment reports produced by the Tampa Bay Nitrogen Management Consortium. Load estimates and adjustment factors are based on regression models in https://drive.google.com/file/d/11NT0NQ2WbPO6pVZaD7P7Z6qjcwO1jxHw/view?usp=drivesdk
#'
#' @concept analyze
#'
#' @importFrom rnoaa ncdc
#'
#' @return A data frame with hydrological load estimates by bay segments for the requested years
#' @export
#'
#' @examples
#' \dontrun{
#' # this function requires an API key
#' # save it to the R environment file (only once)
#' # save the key, do only once
#' cat("NOAA_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n",
#'    file=file.path(normalizePath("~/"), ".Renviron"),
#'    append=TRUE)
#'
#' # retrieve the key after saving, may need to restart R
#' noaa_key <- Sys.getenv('NOAA_key')
#'
#' # get estimates for 2021
#' anlz_hydroload(2021, noaa_key)
#'
#' }
anlz_hydroload <- function(yrs, noaa_key = NULL, trace = FALSE){

  if(!requireNamespace('rnoaa', quietly = TRUE))
    stop("Package \"noaa\" needed for this function to work. Please install it.", call. = FALSE)

  res <- yrs %>%
    tibble::enframe('name', 'year') %>%
    dplyr::group_by(name) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      ests = purrr::map(data, function(x){

        yr <- x$year

        if(trace)
          cat(yr, '\t')

        start <- paste0(yr, "-01-01")
        end <- paste0(yr, "-12-31")

        # download NOAA UWS rainfall station data
        sp_rainfall <- ncdc(datasetid = "GHCND", stationid = "GHCND:USW00092806",
                            datatypeid = "PRCP", startdate = start, enddate = end,
                            limit = 500, add_units = TRUE, token = noaa_key)
        sp_rain <- sp_rainfall$data %>%
          dplyr::summarise(sum = sum(value)/254)

        tia_rainfall <- ncdc(datasetid = "GHCND", stationid = "GHCND:USW00012842",
                             datatypeid = "PRCP", startdate = start, enddate = end,
                             limit = 500, add_units = TRUE, token = noaa_key)
        tia_rain <- tia_rainfall$data %>%
          dplyr::summarise(sum = sum(value)/254)

        # download USGS streamflow data
        hr <- dataRetrieval::readNWISdv("02303000", "00060", start, end) %>%
          dataRetrieval::renameNWISColumns() %>%
          dplyr::summarise(hr_flow = mean(Flow)*0.892998604)
        ar <- dataRetrieval::readNWISdv("02301500", "00060", start, end) %>%
          dataRetrieval::renameNWISColumns() %>%
          dplyr::summarise(ar_flow = mean(Flow)*0.892998604)
        lmr<- dataRetrieval::readNWISdv("02300500", "00060", start, end) %>%
          dataRetrieval::renameNWISColumns() %>%
          dplyr::summarise(lmr_flow = mean(Flow)*0.892998604)
        bkr<- dataRetrieval::readNWISdv("02307359", "00060", start, end) %>%
          dataRetrieval::renameNWISColumns() %>%
          dplyr::summarise(bkr_flow = mean(Flow)*0.892998604)
        wl <- dataRetrieval::readNWISdv("02300042", "00060", start, end) %>%
          dataRetrieval::renameNWISColumns() %>%
          dplyr::summarise(wl_flow = mean(Flow)*0.892998604)
        mr <- dataRetrieval::readNWISdv("02299950", "00060", start, end) %>%
          dataRetrieval::renameNWISColumns() %>%
          dplyr::summarise(mr_flow = mean(Flow)*0.892998604)

        # Bay Segment hydrologic annual estimates
        HB <- data.frame(bs="Hillsborough Bay", stringsAsFactors = FALSE)
        HB$est <- 197.08+(1.84*ar$ar_flow)+(1.91*hr$hr_flow)
        HB$adj <- ifelse(HB$est>753 & HB$est<1110,"NO", "YES")
        HB$factor <- ifelse(HB$adj=="YES",HB$est/908,NA)
        HB$compload <- ifelse(HB$adj=="YES",HB$factor*1451,1451)

        OTB <- data.frame(bs="Old Tampa Bay", stringsAsFactors = FALSE)
        OTB$est <- 154.22+(8.12*bkr$bkr_flow)+(6.73*tia_rain$sum)
        OTB$adj <- ifelse(OTB$est>383 & OTB$est<548,"NO", "YES")
        OTB$factor <- ifelse(OTB$adj=="YES",OTB$est/449,NA)
        OTB$compload <- ifelse(OTB$adj=="YES",OTB$factor*486,486)

        MTB <- data.frame(bs="Middle Tampa Bay", stringsAsFactors = FALSE)
        MTB$est <- -13.78+(1.64*lmr$lmr_flow)+(8.68*sp_rain$sum)
        MTB$adj <- ifelse(MTB$est>524 & MTB$est<756,"NO", "YES")
        MTB$factor <- ifelse(MTB$adj=="YES",MTB$est/646,NA)
        MTB$compload <- ifelse(MTB$adj=="YES",MTB$factor*799,799)

        LTB <- data.frame(bs="Lower Tampa Bay", stringsAsFactors = FALSE)
        LTB$est <- 87.08+(3.69*sp_rain$sum)+(0.79*wl$wl_flow)+(0.62*mr$mr_flow)
        LTB$adj <- ifelse(LTB$est>312 & LTB$est<402,"NO", "YES")
        LTB$factor <- ifelse(LTB$adj=="YES",LTB$est/361,NA)
        LTB$compload <- ifelse(LTB$adj=="YES",LTB$factor*349,349)

        # final table
        TB <- dplyr::bind_rows(HB,OTB,MTB,LTB)

        return(TB)

      })
    )

  out <- res %>%
    dplyr::ungroup() %>%
    tidyr::unnest(data) %>%
    tidyr::unnest(ests) %>%
    dplyr::select(-name) %>%
    dplyr::rename(
      Year = year,
      `Bay Segment` = bs,
      `Hydrology Estimate (million m3)` = est,
      `Adjusted?` = adj,
      `Compliance Load Adjustment Factor` = factor,
      `Compliance Load` = compload
    ) %>%
    dplyr::mutate(
      `Bay Segment` = factor(`Bay Segment`, levels = c('Old Tampa Bay', 'Hillsborough Bay', 'Middle Tampa Bay', 'Lower Tampa Bay'))
    ) %>%
    dplyr::arrange(Year, `Bay Segment`)

  return(out)

}

#' Analyze Fecal Indicator Bacteria categories over time by station or bay segment
#'
#' Analyze Fecal Indicator Bacteria categories over time by station or bay segment
#'
#' @param fibdata input data frame as returned by \code{\link{read_importfib}}, \code{\link{read_importentero}}, or \code{\link{read_importwqp}}, see details
#' @param yrrng numeric vector indicating min, max years to include, defaults to range of years in data, see details
#' @param stas optional vector of stations to include, see details
#' @param bay_segment optional vector of bay segment names to include, supercedes \code{stas} if provided, see details
#' @param lagyr numeric for year lag to calculate categories, see details
#' @param subset_wetdry character, subset data frame to only wet or dry samples as defined by \code{wet_threshold} and \code{temporal_window}? Defaults to \code{"all"}, which will not subset. If \code{"wet"} or \code{"dry"} is specified, \code{\link{anlz_fibwetdry}} is called using the further specified parameters, and the data frame is subsetted accordingly.
#' @param precipdata input data frame as returned by \code{\link{read_importrain}}. columns should be: station, date (yyyy-mm-dd), rain (in inches). The object \code{\link{catchprecip}} has this data from 1995-2023 for select Enterococcus stations. If \code{NULL}, defaults to \code{\link{catchprecip}}.
#' @param temporal_window numeric; required if \code{subset_wetdry} is not \code{"all"}. number of days precipitation should be summed over (1 = day of sample only; 2 = day of sample + day before; etc.)
#' @param wet_threshold  numeric; required if \code{subset_wetdry} is not \code{"all"}. inches accumulated through the defined temporal window, above which a sample should be defined as being from a 'wet' time period
#' @param warn logical to print warnings about stations with insufficient data, default \code{TRUE}
#'
#' @concept show
#'
#' @return A \code{\link[dplyr]{tibble}} object with FIB summaries by year and station including columns for the estimated geometric mean of Enterococcus (marine) or E. coli (fresh) concentrations (\code{gmean}), the proportion of samples exceeding 130 CFU / 100 mL (Enterococcus) or 410 CFU / 100 mL (\code{exced}), the count of samples (\code{cnt}), and a category indicating a letter outcome based on the proportion of exceedences (\code{cat}).  Results can be summarized by bay segment if \code{bay_segment} is not \code{NULL} and the input data is from \code{\link{read_importentero}}.
#'
#' @details This function is used to create output for plotting a matrix stoplight graphic for FIB categories by station. Each station (or bay segment) and year combination is categorized based on the likelihood of fecal indicator bacteria concentrations exceeding some threshold in a given year.  For Enterococcus (marine), the default threshold is 130 CFU / 100 mL in a given year.  For E. coli (fresh), the default threshold is 410 CFU / 100 mL.  The proportions are categorized as A, B, C, D, or E (Microbial Water Quality Assessment or MWQA categories) with corresponding colors, where the breakpoints for each category are <10\%, 10-30\%, 30-50\%, 50-75\%, and >75\% (right-closed) likelihood of exceedence.  By default, the results for each year are based on a right-centered window that uses the previous two years and the current year to calculate probabilities using the monthly samples (\code{lagyr = 3}). See \code{\link{show_fibmatrix}} for additional details.
#'
#' If the input data are from \code{\link{read_importentero}} (baywide assessment), the results can be summarized by bay segment if \code{bay_segment} is not \code{NULL}. The \code{stas} argument is ignored and all stations within each bay segment watershed are used to evaluate the FIB categories.
#'
#' \code{yrrng} can be specified several ways.  If \code{yrrng = NULL}, the year range of the data for the selected changes is chosen.  User-defined values for the minimum and maximum years can also be used, or only a minimum or maximum can be specified, e.g., \code{yrrng = c(2000, 2010)} or \code{yrrng = c(2000, NA)}.  In the latter case, the maximum year will be defined by the data.
#'
#' The default stations if the input is from \code{\link{read_importfib}} (EPC data) and if \code{bay_segment} is \code{NULL} are those used in TBEP report #05-13 (\url{https://drive.google.com/file/d/1MZnK3cMzV7LRg6dTbCKX8AOZU0GNurJJ/view}) for the Hillsborough River Basin Management Action Plan (BMAP) subbasins.  These include Blackwater Creek (WBID 1482, EPC stations 143, 108), Baker Creek (WBID 1522C, EPC station 107), Lake Thonotosassa (WBID 1522B, EPC stations 135, 118), Flint Creek (WBID 1522A, EPC station 148), and the Lower Hillsborough River (WBID 1443E, EPC stations 105, 152, 137).  Other stations can be plotted using the \code{stas} argument.
#'
#' Input from \code{\link{read_importwqp}} for Manatee County (21FLMANA_WQX), Pasco County (21FLPASC_WQX), or Polk County (21FLPOLK_WQX) FIB data can also be used.  The function has not been tested for other organizations.
#'
#' @export
#'
#' @importFrom dplyr "%>%"
#'
#' @seealso \code{\link{show_fibmatrix}}
#'
#' @examples
#' anlz_fibmatrix(fibdata)
#'
#' # use different dataset
#' anlz_fibmatrix(enterodata, lagyr = 1)
#'
#' # subset to only wet samples
#' anlz_fibmatrix(enterodata, lagyr = 1, subset_wetdry = "wet",
#'                temporal_window = 2, wet_threshold = 0.5)
#'
#' # Manatee County data
#' anlz_fibmatrix(mancofibdata, lagyr = 1)
anlz_fibmatrix <- function(fibdata, yrrng = NULL, stas = NULL, bay_segment = NULL,
                           lagyr = 3, subset_wetdry = c("all", "wet", "dry"),
                           precipdata = NULL, temporal_window = NULL, wet_threshold = NULL,
                           warn = TRUE){

  geomean <- function(x){prod(x, na.rm = T)^(1/length(na.omit(x)))}

  subset_wetdry <- match.arg(subset_wetdry)

  # check if epchc data
  isepchc <- exists("epchc_station", fibdata)

  # check if manco, pasco, polco, or hcesd data
  isother <- any(grepl('^manco|^pasco|^polco|^hcesd', names(fibdata)))

  # checks for epc data
  if(isepchc){

    fibdata <- fibdata %>%
      dplyr::rename(
        station = epchc_station
      ) %>%
      dplyr::mutate(
        indic = dplyr::case_when(
          !is.na(entero) & class %in% c('3M', '2') ~ entero,
          !is.na(ecoli) & class %in% c('3F', '1') ~ ecoli
        ),
        class = dplyr::case_when(
          class %in% c('3M', '2') ~ 'Marine',
          class %in% c('3F', '1') ~ 'Fresh'
        )
      ) %>%
      dplyr::filter(!is.na(indic))

    # assign default stations from TBEP report #05-13
    if(is.null(stas))
      stas <- c(143, 108, 107, 135, 118, 148, 105, 152, 137)

    # error if subset_wetdry attempted with epchc
    if(subset_wetdry %in% c('wet', 'dry'))
      stop('Subset to wet or dry samples not supported for epchc data')

    # error if user tries to subset by bay segment for epchc
    if(!is.null(bay_segment))
      stop('Bay segment subsetting not applicable for epchc data')

  }

  # checks for manco, pasco, polco, or hcesd data
  if(isother){

    # # assign default stations from TBEP report #05-13
    # if(is.null(stas))
    #   stas <- c(143, 108, 107, 135, 118, 148, 105, 152, 137)

    # error if subset_wetdry attempted with manco data
    if(subset_wetdry %in% c('wet', 'dry'))
      stop('Subset to wet or dry samples not supported for County data')

    # error if user tries to subset by bay segment for epchc
    if(!is.null(bay_segment))
      stop('Bay segment subsetting not applicable for County data')

    fibdata <- fibdata %>%
      dplyr::filter(!is.na(val)) %>%
      dplyr::filter(
        (class == 'Fresh' & var %in% 'ecoli') | (class == 'Marine' & var == 'entero')
      ) %>%
      dplyr::rename_with(~ "station", dplyr::matches("^(manco|pasco|polco|hcesd)_station$")) %>%
      dplyr::select(-qual, -uni, -Sample_Depth_m, -var) %>%
      dplyr::rename(indic = val)

  }

  # checks for non-epc data
  if(!isepchc & !isother){

    # check bay segments
    if(!is.null(bay_segment)){

      segs <- c("OTB", "HB", "MTB", "LTB", "BCB", "MR")
      chk <- !bay_segment %in% segs
      if(any(chk)){
        stop('Invalid bay_segment(s): ', paste(bay_segment[chk], collapse = ', '))
      }
    }

    fibdata <- fibdata %>%
      dplyr::rename(indic = entero) %>%
      dplyr::mutate(class = 'Marine')

  }

  # subset to wet or dry samples, if specified
  if(subset_wetdry != "all"){

    # make sure necessary info is provided
    if(is.null(temporal_window) | is.null(wet_threshold))
      stop("temporal_window and wet_threshold must both be provided in order to subset to wet or dry samples")

    # if precip data isn't specified, use the catchprecip object
    if(is.null(precipdata)){
      precipdata <- catchprecip
    }

    # run the anlz_fibwetdry function
    dat <- anlz_fibwetdry(fibdata = fibdata,
                          precipdata = precipdata,
                          temporal_window = temporal_window,
                          wet_threshold = wet_threshold) %>%
      dplyr::mutate(wetdry = dplyr::case_when(wet_sample == TRUE ~ "wet",
                                              wet_sample == FALSE ~ "dry",
                                              .default = NA_character_))
    # filter the data frame
    fibdata <- dat %>%
      dplyr::filter(wetdry == subset_wetdry)

  }

  # all stations if stas is NULL
  if(is.null(stas) & is.null(bay_segment))
    stas <- fibdata %>%
      dplyr::pull(station) %>%
      unique() %>%
      sort()

  # all stations in a bay segment if bay_segment is not NULL
  if(!is.null(bay_segment))
    stas <- fibdata %>%
      dplyr::filter(bay_segment %in% !!bay_segment) %>%
      dplyr::pull(station) %>%
      unique() %>%
      sort()

  # check stations
  chk <- stas %in% fibdata$station
  if(any(!chk))
    stop('Station(s) not found in fibdata: ', paste(stas[!chk], collapse = ', '))

  # get year range from data if not provided
  if(any(is.na(yrrng)) | is.null(yrrng)){
    valyrs <- fibdata %>%
      dplyr::filter(station %in% stas) %>%
      dplyr::filter(!is.na(indic) | indic < 0) %>%
      dplyr::pull(yr) %>%
      range(na.rm = T)

    if(is.null(yrrng))
      yrrng <- valyrs

    if(is.na(yrrng[1]))
      yrrng[1] <- valyrs[1]

    if(is.na(yrrng[2]))
      yrrng[2] <- valyrs[2]

  }

  # valid stations with sufficient data for lagyr
  stasval <- fibdata %>%
    dplyr::filter(station %in% stas) %>%
    dplyr::filter(yr >= (yrrng[1] - (lagyr - 1)) & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(indic) | indic < 0) %>%
    tidyr::complete(
      yr = tidyr::full_seq(c(min(yr) - (lagyr - 1), yr), 1),
      tidyr::nesting(station)
    ) %>%
    dplyr::summarise(
      hasdat = sum(any(!is.na(indic))),
      .by = c('station', 'yr')
    ) %>%
    arrange(station, yr) %>%
    dplyr::mutate(
      chkyr = stats::filter(hasdat, rep(1, lagyr), sides = 1, method = 'convolution'),
      .by = station
    ) %>%
    dplyr::filter(any(chkyr >= lagyr), .by = station)

  # check if all stations invalid for lagyr
  if(nrow(stasval) == 0){
    stop('Insufficient data for lagyr')
  }

  stasval <- stasval %>%
    dplyr::pull(station) %>%
    unique()

  chk <- !stas %in% stasval

  # check if some stations valid for lagyr
  if(sum(chk) > 0 & sum(chk) < length(chk) & is.null(bay_segment)){
    if(warn)
      warning('Stations with insufficient data for lagyr: ', paste(stas[chk], collapse = ', '))
    stas <- stas[!chk]
  }

  grp <- 'station'
  levs <- stas
  if(!is.null(bay_segment)){
    grp <- 'bay_segment'
    levs <- segs
  }

  # thresholds
  thrsh <- tibble::tibble(
    class = c('Marine', 'Fresh'),
    thrsh = c(130, 410)
  )

  # get geomean, proportion of sites/bay segments > threshold, and prob of exceedence
  # handles lagged calculations
  dat <- fibdata %>%
    dplyr::filter(station %in% stas) %>%
    dplyr::filter(yr >= (yrrng[1] - (lagyr - 1)) & yr <= yrrng[2]) %>%
    dplyr::filter(!is.na(indic) | indic < 0) %>%
    dplyr::rename(grp = !!grp) %>%
    dplyr::left_join(thrsh, by = 'class') %>%
    tidyr::complete(
      yr = tidyr::full_seq(yr, 1),
      tidyr::nesting(grp)
    ) %>%
    summarise(
      gmean = geomean(indic),
      sumgt = sum(indic > thrsh),
      tot = dplyr::n(),
      Latitude = mean(Latitude, na.rm = TRUE),
      Longitude = mean(Longitude, na.rm = TRUE),
      .by = c('grp', 'yr', 'class')
    ) %>%
    dplyr::arrange(grp, yr) %>%
    dplyr::filter(
      length(unique(yr)) >= lagyr,
      .by = 'grp'
    ) %>%
    dplyr::mutate(
      sumgt = stats::filter(sumgt, rep(1, lagyr), sides = 1, method = 'convolution'),
      tot = stats::filter(tot, rep(1, lagyr), sides = 1, method = 'convolution'),
      .by = 'grp'
    ) %>%
    dplyr::mutate(
      exceed_10_prob = pbinom(sumgt - 1, tot, 0.10, lower.tail = FALSE),
      exceed_30_prob = pbinom(sumgt - 1, tot, 0.30, lower.tail = FALSE),
      exceed_50_prob = pbinom(sumgt - 1, tot, 0.50, lower.tail = FALSE),
      exceed_75_prob = pbinom(sumgt - 1, tot, 0.75, lower.tail = FALSE)
    ) %>%
    dplyr::filter(!is.na(sumgt))

  # Put stations into binomial test groups based on significant exceedances of threshold criteria
  dat$MWQA <- NA
  dat$MWQA[dat$exceed_10_prob >= 0.10] <- 'A'
  dat$MWQA[dat$exceed_10_prob < 0.10 & dat$exceed_30_prob >= 0.10] <- 'B'
  dat$MWQA[dat$exceed_30_prob < 0.10 & dat$exceed_50_prob >= 0.10] <- 'C'
  dat$MWQA[dat$exceed_50_prob < 0.10 & dat$exceed_75_prob >= 0.10] <- 'D'
  dat$MWQA[dat$exceed_75_prob < 0.10] <- 'E'

  out <- dat %>%
    dplyr::select(yr, grp, class, gmean, Latitude, Longitude, cat = MWQA) %>%
    dplyr::mutate(
      grp = factor(grp, levels = levs)
    ) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    tidyr::complete(yr = yrrng[1]:yrrng[2], grp) %>%
    dplyr::filter(!is.na(gmean))

  return(out)

}

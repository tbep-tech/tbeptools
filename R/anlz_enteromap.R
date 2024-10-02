#' Assign threshold categories to Enterococcus data
#'
#' @param fibdata data frame of Enterococcus sample data as returned by \code{\link{enterodata}} or \code{\link{anlz_fibwetdry}}
#' @param yrsel optional numeric to filter data by year
#' @param mosel optional numeric to filter data by month
#' @param areasel optional character string to filter output by stations in the \code{long_name} column of \code{enterodata}, see details
#' @param wetdry logical; if \code{TRUE}, incorporate wet/dry differences (this will result in a call to \code{\link{anlz_fibwetdry}}, in which case \code{temporal_window} and \code{wet_threshold} are required). If \code{FALSE} (default), do not differentiate between wet and dry samples.
#' @param precipdata input data frame as returned by \code{\link{read_importrain}}. columns should be: station, date (yyyy-mm-dd), rain (in inches). The object \code{\link{catchprecip}} has this data from 1995-2023 for select Enterococcus stations. If \code{NULL}, defaults to \code{\link{catchprecip}}.
#' @param temporal_window numeric; required if \code{wetdry} is \code{TRUE}. number of days precipitation should be summed over (1 = day of sample only; 2 = day of sample + day before; etc.)
#' @param wet_threshold  numeric; required if \code{wetdry} is \code{TRUE}. inches accumulated through the defined temporal window, above which a sample should be defined as being from a 'wet' time period
#' @param assf logical indicating if the data are further processed as a simple features object with additional columns for \code{\link{show_enteromap}}
#'
#' @details This function is based on \code{\link{anlz_fibmap}}, but is specific to Enterococcus data downloaded via \code{\link{read_importentero}}. It creates categories for mapping using \code{\link{show_enteromap}}. Optionally, if samples have been defined as 'wet' or not via \code{\link{anlz_fibwetdry}}, this can be represented via symbols on the map.  Categories based on relevant thresholds are assigned to each observation.  The categories are specific to Enterococcus in marine waters (\code{class} of 2 or 3M). A station is categorized into one of four ranges defined by the thresholds as noted in the \code{cat} column of the output, with corresponding colors appropriate for each range as noted in the \code{col} column of the output.
#'
#' The \code{areasel} argument can indicate valid entries in the \code{long_name} column of \code{enterodata}.  For example, use \code{"Old Tampa Bay"} for stations in the subwatershed of Old Tampa Bay, where rows in  \code{enterodata} are filtered based on the the selection.  All stations are returned if this argument is set as \code{NULL} (default). All valid options for \code{areasel} include \code{"Old Tampa Bay"}, \code{"Hillsborough Bay"}, \code{"Middle Tampa Bay"}, \code{"Lower Tampa Bay"}, \code{"Boca Ciega Bay"}, or \code{"Manatee River"}.  One to any of the options can be used.
#'
#' @return A \code{data.frame} similar to \code{fibdata} if \code{assf = FALSE} with additional columns describing station categories and optionally filtered by arguments passed to the function. A \code{sf} object if \code{assf = TRUE} with additional columns for \code{\link{show_enteromap}}.
#'
#' @export
#'
#' @examples
#' anlz_enteromap(enterodata, yrsel = 2020, mosel = 9)
#'
#' # differentiate wet/dry samples in that time frame
#' anlz_enteromap(enterodata, yrsel = 2020, mosel = 9, wetdry = TRUE,
#'                temporal_window = 2, wet_threshold = 0.5)
#'
#' # as sf object
#' anlz_enteromap(enterodata, assf = TRUE)
anlz_enteromap <- function (fibdata, yrsel = NULL, mosel = NULL, areasel = NULL, wetdry = FALSE,
                            precipdata = NULL, temporal_window = NULL,
                            wet_threshold = NULL, assf = FALSE){

  levs <- util_fiblevs()

  cols <- c("#2DC938", "#E9C318", "#EE7600", "#CC3231")

  out <- fibdata %>%
    select(station, long_name, yr, mo, Latitude, Longitude, entero) %>%
    dplyr::mutate(cat = cut(entero, breaks = levs$enterolev, right = F, levs$enterolbs),
                  col = cut(entero, breaks = levs$enterolev, right = F, cols),
                  col = as.character(col),
                  ind = "Enterococcus",
                  indnm = "entero",
                  conc = entero)

  if (wetdry == TRUE){

    # make sure necessary info is provided
    stopifnot("temporal_window and wet_threshold must both be provided in order to subset to wet or dry samples" = !is.null(temporal_window) & !is.null(wet_threshold))

    # if precip data isn't specified, use the catchprecip object
    if(is.null(precipdata)){
      precipdata <- catchprecip
    }
    # run the anlz_fibwetdry function
    fibwetdry <- anlz_fibwetdry(fibdata = fibdata,
                          precipdata = precipdata,
                          temporal_window = temporal_window,
                          wet_threshold = wet_threshold)

    out$wet_sample = fibwetdry$wet_sample

  }

  # filter by area
  if(!is.null(areasel)){

    areasvc <- c("Old Tampa Bay", "Hillsborough Bay", "Middle Tampa Bay", "Lower Tampa Bay",
        "Boca Ciega Bay", "Manatee River")

    areasel <- match.arg(areasel, areasvc, several.ok = TRUE)

    out <- out %>%
      dplyr::filter(long_name %in% areasel)

  }

  if (!is.null(yrsel)) {
    yrsel <- match.arg(as.character(yrsel), unique(out$yr))
    out <- out %>%
      dplyr::filter(yr %in% yrsel)
  }
  if (!is.null(mosel)) {
    mosel <- match.arg(as.character(mosel), 1:12)
    out <- out %>%
      dplyr::filter(mo %in% mosel)
  }

  chk <- length(na.omit(out$cat)) == 0
  if (chk)
    stop("No FIB data for ", paste(lubridate::month(mosel,
                                                    label = T), yrsel, sep = " "))

  out <- tibble::tibble(out)

  if(assf){

    # make a column even if wetdry wasn't selected
    # and if it was, give it something other than true/false
    if (wetdry == FALSE) {
      out$wet_sample = factor("all",
                                 levels = "all",
                                 labels = "all")
    } else {
      out <- out %>%
        dplyr::mutate(wet_sample = factor(dplyr::case_when(wet_sample == TRUE ~ "wet",
                                                           .default = "dry"),
                                          levels = c("dry", "wet"),
                                          labels = c("dry", "wet")))
    }

    # create the object to map
    tomap <- out %>%
      dplyr::filter(!is.na(Longitude)) %>%
      dplyr::filter(!is.na(Latitude)) %>%
      dplyr::filter(!is.na(cat)) %>%
      sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326, remove = F) %>%
      dplyr::mutate(
        colnm = factor(col,
                       levels = c('#2DC938', '#E9C318', '#EE7600', '#CC3231'),
                       labels = c('green', 'yellow', 'orange', 'red')
        ),
        conc = round(conc, 1)
      ) %>%
      tidyr::unite('grp', indnm, colnm, wet_sample, remove = F)

    # create levels for group, must match order of icons list
    levs <- expand.grid(levels(tomap$colnm), unique(tomap$indnm), levels(tomap$wet_sample)) %>%
      unite('levs', Var2, Var1, Var3) %>%
      pull(levs)

    # get correct levels
    out <- tomap %>%
      dplyr::mutate(
        grp = factor(grp, levels = levs),
        lab = paste0('<html>Station Number: ', station, '<br>Sample Condition: ', wet_sample, '<br> Category: ', cat, ' (', conc, '/100mL)</html>')
      ) %>%
      dplyr::select(-colnm, -indnm)

  }

  return(out)

}

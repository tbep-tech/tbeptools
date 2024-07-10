#' Assign threshold categories to Enterococcus data
#'
#' @param fibdata data frame of Enterococcus sample data as returned by \code{\link{enterodata}} or \code{\link{anlz_fibwetdry}}
#' @param yrsel optional numeric to filter data by year
#' @param mosel optional numeric to filter data by month
#' @param wetdry logical; if \code{TRUE}, incorporate wet/dry differences. if \code{FALSE} (default), do not differentiate between wet and dry samples.
#'
#' @details This function is based on \code{\link{anlz_fibmap}}, but is specific to Enterococcus data downloaded via \code{\link{read_importentero}}. It creates categories for mapping using \code{\link{show_enteromap}}. Optionally, if samples have been defined as 'wet' or not via \code{\link{anlz_fibwetdry}}, this can be represented via symbols on the map.  Categories based on relevant thresholds are assigned to each observation.  The categories are specific to Enterococcus in marine waters (\code{class} of 2 or 3M). A station is categorized into one of four ranges defined by the thresholds as noted in the \code{cat} column of the output, with corresponding colors appropriate for each range as noted in the \code{col} column of the output.
#'
#' @return A \code{data.frame} similar to \code{fibdata} with additional columns describing station categories and optionally filtered by arguments passed to the function
#'
#' @export
#'
#' @examples
#' anlz_enteromap(enterodata, yrsel = 2020, mosel = 9)
#'
#' # wet/dry samples
#' entero_wetdry <- anlz_fibwetdry(enterodata, catch_precip)
#' anlz_enteromap(entero_wetdry, yrsel = 2020, mosel = 9, wetdry = TRUE)
#'
#' # this will give the same output as the first example
#' anlz_enteromap(entero_wetdry, yrsel = 2020, mosel = 9, wetdry = FALSE)
anlz_enteromap <- function (fibdata, yrsel = NULL, mosel = NULL, wetdry = FALSE)
{
  levs <- util_fiblevs()
  cols <- c("#2DC938", "#E9C318", "#EE7600", "#CC3231")
  out <- fibdata %>% select(station, yr,
                            mo, Latitude, Longitude, ecocci) %>%
    dplyr::mutate(cat = cut(ecocci, breaks = levs$ecoccilev, right = F, levs$ecoccilbs),
                  col = cut(ecocci, breaks = levs$ecoccilev, right = F, cols),
                  col = as.character(col),
                  ind = "Enterococcus",
                  indnm = "ecocci",
                  conc = ecocci)
  if (wetdry == TRUE) {
    stopifnot("fibdat does not contain a 'wet_sample' column" = exists("wet_sample", fibdata))
    out$wet_sample = fibdata['wet_sample']
  }
  if (!is.null(yrsel)) {
    yrsel <- match.arg(as.character(yrsel), unique(out$yr))
    out <- out %>% dplyr::filter(yr %in% yrsel)
  }
  if (!is.null(mosel)) {
    mosel <- match.arg(as.character(mosel), 1:12)
    out <- out %>% dplyr::filter(mo %in% mosel)
  }
  chk <- length(na.omit(out$cat)) == 0
  if (chk)
    stop("No FIB data for ", paste(lubridate::month(mosel,
                                                    label = T), yrsel, sep = " "))
  return(out)
}

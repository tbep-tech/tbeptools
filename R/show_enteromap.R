#' Map Enterococcus results by month, year, and location
#'
#' @inheritParams anlz_enteromap
#' @param addsta logical to add station labels to the map, default \code{FALSE}
#'
#' @return A \code{leaflet} map for the selected year, month, and area showing stations and FIB concentration category
#'
#' @details Placing the mouse cursor over an item on the map will reveal additional information about a station.
#'
#' @concept show
#'
#' @seealso \code{\link{anlz_enteromap}} for details on the categories
#' @export
#'
#' @examples
#' show_enteromap(enterodata, yrsel = 2020, mosel = 9)
#'
#' # wet/dry samples
#' show_enteromap(enterodata, yrsel = 2020, mosel = 9, wetdry = TRUE,
#'                temporal_window = 2, wet_threshold = 0.5)
#'
#' # Old Tampa Bay only
#' show_enteromap(enterodata, yrsel = 2020, mosel = 9, areasel = "Old Tampa Bay")
show_enteromap <- function(fibdata, yrsel, mosel, areasel = NULL, wetdry = FALSE,
                           precipdata = NULL, temporal_window = NULL,
                           wet_threshold = NULL, addsta = FALSE){

  # get categories
  fibmap <- anlz_enteromap(fibdata, yrsel = yrsel, mosel = mosel, areasel = areasel,
                           wetdry = wetdry, precipdata = precipdata,
                           temporal_window = temporal_window, wet_threshold = wet_threshold,
                           assf = TRUE)

  # create custom icon list for fib categories
  icons <- util_fibicons(indic = 'entero')

  # legend as HTML string
  # using previously created code and icons that have ecoli in the name -
  # so monkeying around a bit to make shapes match correctly
  levs <- util_fiblevs()
  leg <- tibble::tibble(
    src = paste0('https://github.com/tbep-tech/tbeptools/blob/master/inst/', basename(sapply(icons, `[[`, 1)), '?raw=true'),
    brk = rep(levs$enterolbs, times = 2)
  ) %>%
    tidyr::unite('val', src, brk, sep = "' style='width:10px;height:10px;'> ") %>%
    dplyr::mutate(
      val = paste0("<img src='", val)
    ) %>%
    dplyr::pull(val)
  enterodryleg <- leg %>%
    grep('ecoli', ., value = T) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>Dry samples</b><br/>#/100mL<br/>', .)
  enterowetleg <- leg %>%
    grep('entero', ., value = T) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>Wet samples</b><br/>#/100mL<br/>', .)
  enteroallleg <- leg %>%
    grep('ecoli', ., value = T) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>All samples</b><br/>#/100mL<br/>', .)

  # create map
  out <- util_map(fibmap) %>%
    leaflet::addMarkers(
      data = fibmap,
      lng = ~Longitude,
      lat = ~Latitude,
      icon = ~icons[as.numeric(grp)],
      label = ~lapply(as.list(lab), util_html),
      layerId = ~station
    )

  # add appropriate legends
  if(wetdry == TRUE){
    out <- out %>%
      leaflet::addControl(html = enterodryleg, position = 'topright') %>%
      leaflet::addControl(html = enterowetleg, position = 'topright')
  } else {
    out <- out %>%
      leaflet::addControl(html = enteroallleg, position = 'topright')
  }

  # add station labels
  if(addsta){

    out <- out %>%
      leaflet::addLabelOnlyMarkers(
        data = fibmap,
        lng = ~Longitude,
        lat = ~Latitude,
        label = ~station,
        labelOptions = leaflet::labelOptions(noHide = TRUE, textOnly = TRUE)
      )

  }

  return(out)

}

#' Map Fecal Indicator Bacteria (FIB) results by month, year, and location
#'
#' @inheritParams anlz_fibmap
#'
#' @return A \code{leaflet} map for the selected year, month, and area showing stations and FIB concentration category
#'
#' @details Placing the mouse cursor over an item on the map will reveal additional information about a station.
#'
#' @concept show
#'
#' @seealso \code{\link{anlz_fibmap}} for details on the categories
#' @export
#'
#' @examples
#' # show selected year, month
#' show_fibmap(fibdata, yrsel = 2023, mosel = 8)
#'
#' # show selected year, month, and area
#' show_fibmap(fibdata, yrsel = 2020, mosel = 7, areasel = 'Alafia River')
show_fibmap <- function(fibdata, yrsel, mosel, areasel = NULL){

  # get categories
  fibmap <- anlz_fibmap(fibdata, yrsel = yrsel, mosel = mosel, areasel = areasel, assf = TRUE)

  # create custom icon list for fib categories
  icons <- util_fibicons(indic = 'fcolif')

  # legend as HTML string
  levs <- util_fiblevs()
  leg <- tibble::tibble(
    src = paste0('https://github.com/tbep-tech/tbeptools/blob/master/inst/', basename(sapply(icons, `[[`, 1)), '?raw=true'),
    brk = c(levs$ecolilbs, levs$enterolbs)
    ) %>%
    tidyr::unite('val', src, brk, sep = "' style='width:10px;height:10px;'> ") %>%
    dplyr::mutate(
      val = paste0("<img src='", val)
    ) %>%
    dplyr::pull(val)
  ecolileg <- leg %>%
    grep('ecoli', ., value = T) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>Freshwater (<em>E. Coli</em>)</b><br/>#/100mL<br/>', .)
  enteroleg <- leg %>%
    grep('entero', ., value = T) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>Marine (<em>Enterococcus</em>)</b><br/>#/100mL<br/>', .)

  # create map
  out <- util_map(fibmap) %>%
    leaflet::addMarkers(
      data = fibmap,
      lng = ~Longitude,
      lat = ~Latitude,
      icon = ~icons[as.numeric(grp)],
      label = ~lapply(as.list(lab), util_html)
      ) %>%
    leaflet::addControl(html = enteroleg, position = 'topright') %>%
    leaflet::addControl(html = ecolileg, position = 'topright')

  return(out)

}

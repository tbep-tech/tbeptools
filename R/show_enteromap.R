#' Map Enterococcus results by month, year, and location
#'
#' @inheritParams anlz_enteromap
#'
#' @return A \code{leaflet} map for the selected year, month, and area showing stations and FIB concentration category
#'
#' @details Placing the mouse cursor over an item on the map will reveal additional information about a station.
#'
#' @concept anlz
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
show_enteromap <- function(fibdata, yrsel, mosel, wetdry = FALSE,
                           precipdata = NULL, temporal_window = NULL,
                           wet_threshold = NULL){

  # get categories
  fibmap <- anlz_enteromap(fibdata, yrsel = yrsel, mosel = mosel, wetdry = wetdry,
                           precipdata = precipdata, temporal_window = temporal_window,
                           wet_threshold = wet_threshold)

  # make a column even if wetdry wasn't selected
  # and if it was, give it something other than true/false
  if (wetdry == FALSE) {
    fibmap$wet_sample = factor("all",
                               levels = "all",
                               labels = "all")
  } else {
    fibmap <- fibmap %>%
      dplyr::mutate(wet_sample = factor(dplyr::case_when(wet_sample == TRUE ~ "wet",
                                                         .default = "dry"),
                                        levels = c("dry", "wet"),
                                        labels = c("dry", "wet")))
  }

  # create the object to map
  tomap <- fibmap %>%
    dplyr::filter(!is.na(Longitude)) %>%
    dplyr::filter(!is.na(Latitude)) %>%
    dplyr::filter(!is.na(cat)) %>%
    sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326, remove = F) %>%
    dplyr::mutate(
      colnm = factor(col,
                     levels = c('#2DC938', '#E9C318', '#EE7600', '#CC3231'),
                     labels = c('green', 'yellow', 'orange', 'red')
      ),
      conc = round(conc, 1),
      cls = 'Marine'
    ) %>%
    tidyr::unite('grp', indnm, colnm, wet_sample, remove = F)

  # create levels for group, must match order of icons list
  levs <- expand.grid(levels(tomap$colnm), unique(tomap$indnm), levels(tomap$wet_sample)) %>%
    unite('levs', Var2, Var1, Var3) %>%
    pull(levs)

  # get correct levels
  tomap <- tomap %>%
    dplyr::mutate(
      grp = factor(grp, levels = levs),
      lab = paste0('<html>Station Number: ', station, '<br>Class: ', cls, ' (<i>', ind, '</i>)<br> Category: ', cat, ' (', conc, '/100mL)</html>')
    ) %>%
    dplyr::select(-colnm, -indnm)

  # create custom icon list for fib categories
  icons <- leaflet::iconList(
    ecocci_green_wet <- leaflet::makeIcon(iconUrl = system.file('ecoli_green.png', package = 'tbeptools'),
                                          iconWidth = 18, iconHeight = 18),
    ecocci_yellow_wet <- leaflet::makeIcon(iconUrl = system.file('ecoli_yellow.png', package = 'tbeptools'),
                                           iconWidth = 18, iconHeight = 18),
    ecocci_orange_wet <- leaflet::makeIcon(iconUrl = system.file('ecoli_orange.png', package = 'tbeptools'),
                                           iconWidth = 18, iconHeight = 18),
    ecocci_red_wet <- leaflet::makeIcon(iconUrl = system.file('ecoli_red.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
    ecocci_green_dry <- leaflet::makeIcon(iconUrl = system.file('ecocci_green.png', package = 'tbeptools'),
                                          iconWidth = 18, iconHeight = 18),
    ecocci_yellow_dry <- leaflet::makeIcon(iconUrl = system.file('ecocci_yellow.png', package = 'tbeptools'),
                                           iconWidth = 18, iconHeight = 18),
    ecocci_orange_dry <- leaflet::makeIcon(iconUrl = system.file('ecocci_orange.png', package = 'tbeptools'),
                                           iconWidth = 18, iconHeight = 18),
    ecocci_red_dry <- leaflet::makeIcon(iconUrl = system.file('ecocci_red.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18)

  )

  # legend as HTML string
  # using previously created code and icons that have ecoli in the name -
  # so monkeying around a bit to make shapes match correctly
  levs <- util_fiblevs()
  leg <- tibble::tibble(
    src = paste0('https://github.com/tbep-tech/tbeptools/blob/master/inst/', basename(sapply(icons, `[[`, 1)), '?raw=true'),
    brk = rep(levs$ecoccilbs, times = 2)
  ) %>%
    tidyr::unite('val', src, brk, sep = "' style='width:10px;height:10px;'> ") %>%
    dplyr::mutate(
      val = paste0("<img src='", val)
    ) %>%
    dplyr::pull(val)
  ecoccidryleg <- leg %>%
    grep('ecoli', ., value = T) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>Dry samples</b><br/>#/100mL<br/>', .)
  ecocciwetleg <- leg %>%
    grep('ecocci', ., value = T) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>Wet samples</b><br/>#/100mL<br/>', .)
  ecocciallleg <- leg %>%
    grep('ecoli', ., value = T) %>%
    paste(collapse = '<br/>') %>%
    paste0('<b>All samples</b><br/>#/100mL<br/>', .)
  title <- paste0('<b><em>Enterococcus</em><br/>', yrsel, '-', mosel, '</b')


  # create map
  out <- util_map(tomap) %>%
    leaflet::addMarkers(
      data = tomap,
      lng = ~Longitude,
      lat = ~Latitude,
      icon = ~icons[as.numeric(grp)],
      label = ~lapply(as.list(lab), util_html)
    ) %>%
    leaflet::addControl(html = title, position = 'topright')

  # add appropriate legends
  if(wetdry == TRUE){
    out <- out %>%
      leaflet::addControl(html = ecoccidryleg, position = 'topright') %>%
      leaflet::addControl(html = ecocciwetleg, position = 'topright')
  } else {
    out <- out %>%
      leaflet::addControl(html = ecocciallleg, position = 'topright')
  }



  return(out)

}

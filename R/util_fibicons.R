#' Return leaflet icon set for FIB maps
#'
#' @param indic character indicating \code{"entero"}, \code{"entero&ecoli"}, or \code{"fibmat"} for \emph{Enterococcus}, Fecal \emph{Enterococcus} and \emph{E. coli}, or FIB matrix maps, respectively
#'
#' @return A leaflet icon set as returned by \code{\link[leaflet]{iconList}}.
#' @export
#'
#' @details Used internally with \code{\link{show_enteromap}} for wet/dry icons for \emph{Enterococcus}, with \code{\link{show_fibmap}} for \emph{E. Coli}/\emph{Enterococcus} icons (EPCHC data), and with \code{\link{show_fibmatmap}} for matrix annual score category icons for EPCHC and non-EPCHC data.
#'
#' @examples
#' util_fibicons(indic = 'entero')
#' util_fibicons(indic = 'entero&ecoli')
#' util_fibicons(indic = 'fibmat')
util_fibicons <- function(indic){

  indic <- match.arg(indic, c('entero', 'entero&ecoli', 'fibmat'))

  if(indic == 'entero')
    out <- leaflet::iconList(
      entero_green_wet = leaflet::makeIcon(iconUrl = system.file('ecoli_green.png', package = 'tbeptools'),
                                            iconWidth = 18, iconHeight = 18),
      entero_yellow_wet = leaflet::makeIcon(iconUrl = system.file('ecoli_yellow.png', package = 'tbeptools'),
                                             iconWidth = 18, iconHeight = 18),
      entero_orange_wet = leaflet::makeIcon(iconUrl = system.file('ecoli_orange.png', package = 'tbeptools'),
                                             iconWidth = 18, iconHeight = 18),
      entero_red_wet = leaflet::makeIcon(iconUrl = system.file('ecoli_red.png', package = 'tbeptools'),
                                          iconWidth = 18, iconHeight = 18),
      entero_green_dry = leaflet::makeIcon(iconUrl = system.file('entero_green.png', package = 'tbeptools'),
                                            iconWidth = 18, iconHeight = 18),
      entero_yellow_dry = leaflet::makeIcon(iconUrl = system.file('entero_yellow.png', package = 'tbeptools'),
                                             iconWidth = 18, iconHeight = 18),
      entero_orange_dry = leaflet::makeIcon(iconUrl = system.file('entero_orange.png', package = 'tbeptools'),
                                             iconWidth = 18, iconHeight = 18),
      entero_red_dry = leaflet::makeIcon(iconUrl = system.file('entero_red.png', package = 'tbeptools'),
                                          iconWidth = 18, iconHeight = 18)

    )

  if(indic == 'entero&ecoli')
    out <- leaflet::iconList(
      ecoli_green = leaflet::makeIcon(iconUrl = system.file('ecoli_green.png', package = 'tbeptools'),
                                       iconWidth = 18, iconHeight = 18),
      ecoli_yellow = leaflet::makeIcon(iconUrl = system.file('ecoli_yellow.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
      ecoli_orange = leaflet::makeIcon(iconUrl = system.file('ecoli_orange.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
      ecoli_red = leaflet::makeIcon(iconUrl = system.file('ecoli_red.png', package = 'tbeptools'),
                                     iconWidth = 18, iconHeight = 18),
      entero_green = leaflet::makeIcon(iconUrl = system.file('entero_green.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
      entero_yellow = leaflet::makeIcon(iconUrl = system.file('entero_yellow.png', package = 'tbeptools'),
                                         iconWidth = 18, iconHeight = 18),
      entero_orange = leaflet::makeIcon(iconUrl = system.file('entero_orange.png', package = 'tbeptools'),
                                         iconWidth = 18, iconHeight = 18),
      entero_red = leaflet::makeIcon(iconUrl = system.file('entero_red.png', package = 'tbeptools'),
                                      iconWidth = 18, iconHeight = 18)
    )

  if(indic == 'fibmat')
    out <- leaflet::iconList(
      fibmat_green = leaflet::makeIcon(iconUrl = system.file('fibmat_green.png', package = 'tbeptools'),
                                       iconWidth = 18, iconHeight = 18),
      fibmat_yellow = leaflet::makeIcon(iconUrl = system.file('fibmat_yellow.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
      fibmat_orange = leaflet::makeIcon(iconUrl = system.file('fibmat_orange.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
      fibmat_red = leaflet::makeIcon(iconUrl = system.file('fibmat_red.png', package = 'tbeptools'),
                                     iconWidth = 18, iconHeight = 18),
      fibmat_purple = leaflet::makeIcon(iconUrl = system.file('fibmat_purple.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18)
    )

  return(out)

}

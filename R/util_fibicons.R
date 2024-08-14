#' Return leaflet icon set for FIB maps
#'
#' @param indic character indicating \code{"entero"} or \code{"fcolif"} for \emph{Enterococcus} or Fecal Coliform
#'
#' @return A leaflet icon set as returned by \code{\link[leaflet]{iconList}}.
#' @export
#'
#' @details Used internally with \code{\link{show_enteromap}} and \code{\link{show_fibmap}}, former uses wet/dry icons for \emph{Enterococcus} and latter uses \emph{E. Coli}/\emph{Enterococcus} icons
#'
#' @examples
#' util_fibicons(indic = 'entero')
#' util_fibicons(indic = 'fcolif')
util_fibicons <- function(indic){

  indic <- match.arg(indic, c('entero', 'fcolif'))

  if(indic == 'entero')
    out <- leaflet::iconList(
      ecocci_green_wet = leaflet::makeIcon(iconUrl = system.file('ecoli_green.png', package = 'tbeptools'),
                                            iconWidth = 18, iconHeight = 18),
      ecocci_yellow_wet = leaflet::makeIcon(iconUrl = system.file('ecoli_yellow.png', package = 'tbeptools'),
                                             iconWidth = 18, iconHeight = 18),
      ecocci_orange_wet = leaflet::makeIcon(iconUrl = system.file('ecoli_orange.png', package = 'tbeptools'),
                                             iconWidth = 18, iconHeight = 18),
      ecocci_red_wet = leaflet::makeIcon(iconUrl = system.file('ecoli_red.png', package = 'tbeptools'),
                                          iconWidth = 18, iconHeight = 18),
      ecocci_green_dry = leaflet::makeIcon(iconUrl = system.file('ecocci_green.png', package = 'tbeptools'),
                                            iconWidth = 18, iconHeight = 18),
      ecocci_yellow_dry = leaflet::makeIcon(iconUrl = system.file('ecocci_yellow.png', package = 'tbeptools'),
                                             iconWidth = 18, iconHeight = 18),
      ecocci_orange_dry = leaflet::makeIcon(iconUrl = system.file('ecocci_orange.png', package = 'tbeptools'),
                                             iconWidth = 18, iconHeight = 18),
      ecocci_red_dry = leaflet::makeIcon(iconUrl = system.file('ecocci_red.png', package = 'tbeptools'),
                                          iconWidth = 18, iconHeight = 18)

    )

  if(indic == 'fcolif')
    out <- leaflet::iconList(
      ecoli_green = leaflet::makeIcon(iconUrl = system.file('ecoli_green.png', package = 'tbeptools'),
                                       iconWidth = 18, iconHeight = 18),
      ecoli_yellow = leaflet::makeIcon(iconUrl = system.file('ecoli_yellow.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
      ecoli_orange = leaflet::makeIcon(iconUrl = system.file('ecoli_orange.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
      ecoli_red = leaflet::makeIcon(iconUrl = system.file('ecoli_red.png', package = 'tbeptools'),
                                     iconWidth = 18, iconHeight = 18),
      ecocci_green = leaflet::makeIcon(iconUrl = system.file('ecocci_green.png', package = 'tbeptools'),
                                        iconWidth = 18, iconHeight = 18),
      ecocci_yellow = leaflet::makeIcon(iconUrl = system.file('ecocci_yellow.png', package = 'tbeptools'),
                                         iconWidth = 18, iconHeight = 18),
      ecocci_orange = leaflet::makeIcon(iconUrl = system.file('ecocci_orange.png', package = 'tbeptools'),
                                         iconWidth = 18, iconHeight = 18),
      ecocci_red = leaflet::makeIcon(iconUrl = system.file('ecocci_red.png', package = 'tbeptools'),
                                      iconWidth = 18, iconHeight = 18)
    )

  return(out)

}

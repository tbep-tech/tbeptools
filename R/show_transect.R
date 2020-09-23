#' Plot results for a seagrass transect by time and location
#'
#' @param transect data frame returned by \code{\link{read_transect}}
#' @param site chr string indicating site results to plot
#' @param species chr string indicating which species to plot
#' @param varplo chr string indicating which variable to plot
#' @param base_size numeric indicating text scaling size for plot
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#'
#' @family visualize
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#' show_transect(transect, site = 'S3T10', species = 'Halodule', varplo = 'Abundance')
show_transect <- function(transect, site, species = c('Halodule', 'Halophila', 'Ruppia', 'Syringodium', 'Thalassia'),
                          varplo = c('Abundance', 'Blade Length', 'Short Shoot Density'), base_size = 12){

  # sanity checks
  if(!site %in% transect$Transect)
    stop(paste('Transect', site, 'not found'))

  species <- match.arg(species)
  varplo <- match.arg(varplo)

  # prep plot data
  toplo <- transect %>%
    dplyr::filter(Transect %in% !!site) %>%
    dplyr::filter(Savspecies %in% !!species) %>%
    dplyr::filter(var %in% !!varplo) %>%
    dplyr::mutate(
      Year = lubridate::year(Date),
      Site = as.numeric(Site)
    ) %>%
    dplyr::select(Year, Site, aveval) %>%
    na.omit

  if(nrow(toplo) == 0)
    stop(paste('No data for', species, 'at transect', site))

  # legend labels
  leglab <- c('Abundance (BB)', 'Blade length (cm)', expression(paste('Shoot density (', m^-2, ')')))
  names(leglab) <- c('Abundance', 'Blade Length', 'Short Shoot Density')
  leglab <- leglab[varplo]

  # plot
  p <- ggplot2::ggplot(toplo, ggplot2::aes(y = Year, x = Site, size = aveval)) +
    ggplot2::geom_point(alpha = 0.6) +
    ggplot2::scale_size(leglab) +
    ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank()
    ) +
    ggplot2::labs(
      x = 'Transect distance (m)'
    )

  return(p)

}

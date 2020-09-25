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
#' @details All sites along at transect that were surveyed are shown in the plot, including those where the selected species was not found.  The latter is colored in red.
#'
#' @importFrom magrittr %>%
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
  dat <- transect %>%
    dplyr::filter(Transect %in% !!site) %>%
    dplyr::select(-sdval) %>%
    dplyr::filter(var %in% !!varplo) %>%
    tidyr::spread(Savspecies, aveval, fill = 0) %>%
    dplyr::select(Date, Site, val = dplyr::matches(paste0('^', species)))

  # stop if no data for the species, transect
  if(ncol(dat) == 2)
    stop(paste('No data for', species, 'at transect', site))

  dat <- dat %>%
    dplyr::mutate(
      Year = lubridate::year(Date),
      Site = as.numeric(Site),
      pa = ifelse(val == 0, 0, 1)
    )

  # legend labels
  leglab <- c('Abundance (BB)', 'Blade length (cm)', expression(paste('Shoot density (', m^-2, ')')))
  names(leglab) <- c('Abundance', 'Blade Length', 'Short Shoot Density')
  leglab <- leglab[varplo]

  # data with species
  toplo1 <- dat %>%
    filter(pa == 1)

  # data without species
  toplo2 <- dat %>%
    filter(pa == 0)

  # plot
  p <- ggplot2::ggplot(toplo1, ggplot2::aes(y = Year, x = Site)) +
    ggplot2::geom_point(data = toplo2, alpha = 0.6, colour = 'tomato1', size = 1) +
    ggplot2::geom_point(aes(size = val), alpha = 0.6) +
    ggplot2::scale_size(leglab) +
    ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank()
    ) +
    ggplot2::labs(
      x = 'Transect distance (m)',
      title = site,
      subtitle = bquote(italic(.(species)))
    )

  return(p)

}

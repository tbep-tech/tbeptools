#' Plot results for a seagrass transect by time and location
#'
#' @param transect data frame returned by \code{\link{read_transect}}
#' @param site chr string indicating site results to plot
#' @param species chr string indicating one to many of which species to plot
#' @param yrrng numeric indicating year ranges to evaluate
#' @param varplo chr string indicating which variable to plot
#' @param base_size numeric indicating text scaling size for plot
#' @param facet logical indicating if plots are separated into facets by species
#' @param ncol numeric indicating number of columns if \code{facet = TRUE}
#' @param plotly logical if plot is created using plotly
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param sppcol character vector of alternative colors to use for each species, must have length of six
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#'
#' @details All sites along a transect that were surveyed are shown in the plot, including those where the selected species were not found.  The latter is colored in grey hollow points.  Species options include Halodule, Syringodium, Thalassia, Halophila, Ruppia, Caulerpa (attached macroalgae), Dapis (cyanobacteria), and/or Chaetomorpha (drift green algae). Drift or attached macroalgae and cyanobacteria (Dapis) estimates may not be accurate prior to 2021.
#'
#' Note that if \code{plotly = TRUE}, the size legend is not shown.
#'
#' @importFrom dplyr %>%
#'
#' @concept show
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#'
#' # one species
#' show_transect(transect, site = 'S3T10', species = 'Halodule', varplo = 'Abundance')
#'
#' # multiple species, one plot
#' show_transect(transect, site = 'S3T10',
#'   species = c('Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia',
#'     'Caulerpa', 'Dapis', 'Chaetomorpha'),
#'   varplo = 'Abundance')
#'
#' # multiple species, multiple plots
#' show_transect(transect, site = 'S3T10',
#'   species = c('Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia',
#'     'Caulerpa', 'Dapis', 'Chaetomorpha'),
#'   varplo = 'Abundance', facet = TRUE)
show_transect <- function(transect, site, species = c('Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia', 'Caulerpa', 'Dapis', 'Chaetomorpha'),
                          yrrng = c(1998, 2024), varplo = c('Abundance', 'Blade Length', 'Short Shoot Density'), base_size = 12,
                          facet = FALSE, ncol = NULL, plotly = FALSE, width = NULL, height = NULL, sppcol = NULL){

  # species pool
  spp <- c('Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia', 'Caulerpa', 'Dapis', 'Chaetomorpha')

  # sanity checks
  if(!site %in% transect$Transect)
    stop(paste('Transect', site, 'not found'))

  if(any(!species %in% spp))
    stop('Species must be one to many of ', paste(spp, collapse = ', '))

  if(yrrng[1] >= yrrng[2])
    stop('Select different year range')

  # check correct length of optional color vector
  if(!is.null(sppcol))
    if(length(sppcol) != length(spp))
      stop('sppcol required length is eight')

  varplo <- match.arg(varplo)

  # prep plot data
  dat <- try({transect %>%
    dplyr::filter(Transect %in% !!site) %>%
    dplyr::select(-sdval) %>%
    dplyr::filter(var %in% !!varplo) %>%
    dplyr::mutate(
      Savspecies = dplyr::case_when(
        grepl('Caulerpa', Savspecies) ~ 'Caulerpa',
        grepl('Dapis', Savspecies) ~ 'Dapis',
        grepl('Chaetomorpha', Savspecies) ~ 'Chaetomorpha',
        T ~ Savspecies
      )
    ) %>%
    tidyr::spread(Savspecies, aveval, fill = 0) %>%
    dplyr::select(Date, Site, dplyr::matches(paste0('^', species))) %>%
    tidyr::pivot_longer(dplyr::matches(paste0('^', species)), values_to = 'val') %>%
    dplyr::mutate(
      name = factor(name, levels = species)
    )}, silent = T)

  # stop if no data for the species, transect
  if(inherits(dat, 'try-error'))
    stop(paste('No data for', species, 'at transect', site))

  dat <- dat %>%
    dplyr::mutate(
      Year = lubridate::year(Date),
      Site = as.numeric(Site),
      pa = ifelse(val == 0, 0, 1)
    ) %>%
    dplyr::filter(Year >= yrrng[1] & Year <= yrrng[2])

  # sort color palette so its the same regardless of species selected
  if(is.null(sppcol))
    sppcol <- c('#ED90A4', '#CCA65A', '#7EBA68', '#6FB1E7', '#00C1B2', '#D400FF', '#8B2323', '#6AF427')
  names(sppcol) <- spp
  sppcol <- sppcol[levels(dat$name)]

  # legend labels
  leglab <- c('abundance (BB)', 'blade length (cm)', 'shoot density (m-2)')
  names(leglab) <- c('Abundance', 'Blade Length', 'Short Shoot Density')
  leglab <- leglab[varplo]

  # data with species
  toplo1 <- dat %>%
    dplyr::filter(pa == 1) %>%
    dplyr::mutate(val = round(val, 1))

  # data w/o species, no facet
  toplo2 <- dat %>%
    group_by(Date, Site) %>%
    filter(sum(pa) == 0) %>%
    ungroup() %>%
    select(Year, Site) %>%
    unique()

  # data w/o species, facet
  toplo3 <- dat %>%
    dplyr::filter(pa == 0)

  if(!facet)
    p <- ggplot2::ggplot(toplo1, ggplot2::aes(y = Year, x = Site)) +
      ggplot2::geom_point(data = toplo2, alpha = 0.6, colour = 'darkgrey', size = 0.5) +
      ggplot2::geom_point(aes(size = val, fill = name), alpha = 0.6, pch = 21) +
      ggplot2::scale_fill_manual(values = sppcol)

  if(facet)
    p <- ggplot2::ggplot(toplo1, ggplot2::aes(y = Year, x = Site, group = name)) +
      ggplot2::geom_point(data = toplo3, alpha = 0.6, colour = 'darkgrey', size = 0.5) +
      ggplot2::geom_point(aes(size = val, fill = name), alpha = 0.6, pch = 21,) +
      ggplot2::scale_fill_manual(values = sppcol) +
      ggplot2::guides(fill = 'none') +
      ggplot2::facet_wrap(~name, ncol = ncol)

  # finish plot
  p <- p +
    ggplot2::scale_size(breaks = as.numeric(levels(factor(toplo1$val)))) +
    ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(hjust = 0)
    ) +
    ggplot2::labs(
      x = 'Transect distance (m)',
      title = paste0(site, ', ', leglab),
      size = NULL,
      fill = NULL
    )

  if(plotly)
    p <- plotly::ggplotly(p, width = width, height = height) %>%
      plotly::config(
        toImageButtonOptions = list(
          format = "svg",
          filename = "myplot"
        )
      )

  return(p)

}

#' Plot frequency occurrence for a seagrass transect by time for all species
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param site chr string indicating site results to plot
#' @param species chr string indicating which species to plot
#' @param yrrng numeric indicating year ranges to evaluate
#' @param abund logical indicating if abundance averages are plotted instead of frequency occurrence
#' @param sppcol character vector of alternative colors to use for each species, must have length of six
#'
#' @return A \code{\link[plotly]{plotly}} object
#' @export
#'
#' @details This plot provides a quick visual assessment of how frequency occurrence or abundance for multiple species has changed over time at a selected transect.
#'
#' @importFrom dplyr %>%
#'
#' @concept show
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#' transectocc <- anlz_transectocc(transect)
#' show_transectsum(transectocc, site = 'S3T10')
show_transectsum <- function(transectocc, site, species = c('Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia', 'Caulerpa'),
                             yrrng = c(1998, 2021), abund = FALSE, sppcol = NULL){

  # species pool
  spp <- c('Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia', 'Caulerpa')

  # sanity checks
  if(!site %in% transectocc$Transect)
    stop(paste('Transect', site, 'not found'))

  if(!any(species %in% spp))
    stop(paste('Species must be one to many of', paste(spp, collapse = ', ')))

  if(yrrng[1] >= yrrng[2])
    stop('Select different year range')

  # check correct length of optional color vector
  if(!is.null(sppcol))
    if(length(sppcol) != length(spp))
      stop('sppcol required length is six')

  # sort out variable names and labels
  val <- 'foest'
  ylb <- 'Frequency occurrence'
  if(abund){
    val <- 'bbest'
    ylb <- 'Abundance (BB)'
  }

  # prep plot data
  toplo <- transectocc %>%
    dplyr::filter(Transect %in% !!site) %>%
    dplyr::filter(Savspecies %in% !!species) %>%
    dplyr::rename(val = !!val) %>%
    dplyr::filter(val > 0) %>%
    dplyr::mutate(
      Savspecies = factor(Savspecies),
      yr = lubridate::year(Date)
    ) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::group_by(yr, Savspecies) %>%
    dplyr::summarise(val = mean(val, na.rm = T))

  # sort color palette so its the same regardless of species selected
  if(is.null(sppcol))
    sppcol <- c('#ED90A4', '#CCA65A', '#7EBA68', '#6FB1E7', '#00C1B2', '#D400FF')
  names(sppcol) <- spp
  sppcol <- sppcol[levels(toplo$Savspecies)]

  # stop if no data for the species, transect
  if(nrow(toplo) == 0)
    stop(paste('No data for', paste0(species, collapse = ', '), 'at transect', site))

  # get vertical lines, this is stupid
  # vertical lines in plots

  dts <- toplo %>%
    dplyr::group_by(yr) %>%
    dplyr::summarise(val = sum(val)) %>%
    dplyr::ungroup()

  vrts <- list()

  for(i in 1:nrow(dts)){

    vrtsi <- list(list(
      type = "line",
      y0 = 0,
      y1 = dts[[i, 'val']],
      xref = "x",
      x0 = dts[[i, 'yr']],
      x1 = dts[[i, 'yr']],
      line = list(color = 'grey', width = 0.5, opacity = 0.5)
    ))

    vrts <- c(vrts, vrtsi)

  }

  # seagrass plot
  p <- plotly::plot_ly(toplo) %>%
    plotly::add_markers(x = ~yr, y = ~val, color = ~factor(Savspecies), colors = sppcol, stackgroup = 'one', mode = 'none', marker = list(opacity = 0, size = 0)) %>%
    plotly::layout(
      yaxis = list(title = ylb),
      xaxis = list(title = NA, gridcolor = '#FFFFFF', tickvals = as.list(unique(toplo$yr))),
      barmode = 'stack',
      showlegend = T,
      legend = list(title = list(text = 'Species')),
      shapes = vrts,
      title = site
    ) %>%
    plotly::config(
      toImageButtonOptions = list(
        format = "svg",
        filename = "myplot"
      )
    )

  return(p)

}

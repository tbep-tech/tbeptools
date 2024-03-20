#' Make a bar plot for transect training group comparisons
#'
#' @param transect data frame returned by \code{\link{read_transect}}
#' @param yr numeric for year of training data to plot
#' @param site chr string indicating site results to plot
#' @param species chr string indicating which species to plot
#' @param varplo chr string indicating which variable to plot
#' @param base_size numeric indicating text scaling size for plot
#' @param xtxt numeric indicating text size for x-axis labels
#' @param size numeric indicating line size
#'
#' @concept show
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#'
#' @examples
#' transect <- read_transect(training = TRUE)
#' show_compplot(transect, yr = 2023, site = '2', species = 'Halodule', varplo = 'Abundance')
show_compplot <- function(transect, yr, site, species = c('Halodule', 'Syringodium', 'Thalassia', 'Halophila', 'Ruppia'),
                          varplo = c('Abundance', 'Blade Length', 'Short Shoot Density'), base_size = 18, xtxt = 10, size = 1){

  # arguments
  species <- match.arg(species)
  varplo <- match.arg(varplo)

  # labels

  # legend labels
  lbs <- c('Abundance (BB)', 'Blade length (cm, +/- 1 sd)', expression(paste('Shoot density (', m^-2, ', +/- 1 sd)')))
  names(lbs) <- c('Abundance', 'Blade Length', 'Short Shoot Density')
  xlb <- lbs[[varplo]]
  ttl <- paste('Site', site)
  sublbs <- c('Halodule wrightii', 'Ruppia maritima', 'Syringodium filiforme', 'Thalassia testudinum')
  names(sublbs) <- c('Halodule', 'Ruppia', 'Syringodium', 'Thalassia')
  subttl <- sublbs[[species]]

  # data to plot
  toplo <- transect %>%
    dplyr::filter(yr %in% !!yr) %>%
    dplyr::filter(Site %in% site) %>%
    dplyr::filter(Savspecies %in% species) %>%
    dplyr::filter(var %in% varplo)

  # get summary stats
  sumplo <- toplo %>%
    dplyr::group_by(var) %>%
    dplyr::summarise(
      Median = median(aveval, na.rm = TRUE),
      Average = mean(aveval, na.rm = TRUE)
    ) %>%
    tidyr::gather('sumvar', 'sumval', Median, Average) %>%
    dplyr::mutate(sumvar = factor(sumvar, levels = c('Average', 'Median')))

  # plot
  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = grp, y = aveval)) +
    ggplot2::geom_bar(stat = 'identity', alpha = 0.7) +
    ggplot2::labs(
      y = xlb,
      title = ttl,
      subtitle = bquote(italic(.(subttl)))
    ) +
    # ggplot2::guides(x = ggplot2::guide_axis(n.dodge = 2)) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::theme_bw(base_size = base_size) +
    ggplot2::theme(
      panel.border = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(size = xtxt),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor.x = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank(),
      legend.position = 'bottom'
    )

  # add error bar and both summary lines if not abundance
  if(!varplo %in% 'Abundance'){

    p <- p +
      ggplot2::geom_errorbar(ggplot2::aes(ymin = aveval - sdval, ymax = aveval + sdval), width = 0.25) +
      ggplot2::geom_hline(data = sumplo, ggplot2::aes(yintercept = sumval, linetype = sumvar), color = 'red', size = size) +
      ggplot2::scale_linetype_manual(values = c(Average = 'solid', Median = 'dotted'))

  }

  # add mean summary lines if abundance
  if(varplo %in% 'Abundance'){

    sumplo <- sumplo %>%
      dplyr::filter(sumvar %in% 'Median')

    p <- p +
      ggplot2::geom_hline(data = sumplo, ggplot2::aes(yintercept = sumval, linetype = sumvar), color = 'red', size = size) +
      ggplot2::scale_linetype_manual(values = c(Average = 'solid', Median = 'dotted'))

  }

  p <- p +
    ggplot2::labs(
      x = 'Crew'
    )
  return(p)

}

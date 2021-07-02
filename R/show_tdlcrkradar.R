#' Radar plots for tidal creek indicators
#'
#' Radar plots for tidal creek indicators
#'
#' @param id numeric indicating the \code{id} number of the tidal creek to plot
#' @param cntdat output from \code{\link{anlz_tdlcrkindic}}
#' @param col color input for polygon and line portions
#' @param ptsz numeric size of points
#' @param lbsz numeric for size of text labels
#' @param valsz numeric for size of numeric value labels
#' @param brdwd numeric for polygon border width
#'
#'
#' @return A radar plot
#' @export
#'
#' @details See details in \code{\link{anlz_tdlcrkindic}} for an explanation of the indicators
#'
#' Internal code borrowed heavily from \code{\link[fmsb]{radarchart}}.
#'
#' @concept show
#'
#' @examples
#' cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018, radar = TRUE)
#' show_tdlcrkradar(35, cntdat)
show_tdlcrkradar <- function (id, cntdat, col = '#338080E6', ptsz = 1, lbsz = 0.8, valsz = 1, brdwd = 5){

  axistype <- 3
  seg <- 5
  pfcol <- ggplot2::alpha(col, 0.4)
  cglcol <- "grey"
  axislabcol <- "grey"
  caxislabels <- seq(0, 100, 20)

  # prep
  toplo <- cntdat %>%
    dplyr::filter(id == !!id) %>%
    dplyr::select(JEI, var, val) %>%
    dplyr::mutate(
      var = factor(var,
        levels = c('chla_ind', 'tsi_ind', 'tn_ind', 'nox_ind', 'do_prop', 'ch_tn_rat_ind'),
        labels = c('Chloropyll', 'TSI score', 'Total Nitrogen', 'Nitrate Ratio', 'DO Saturation', 'Chl/TN Ratio'))
    ) %>%
    tidyr::spread(var, val) %>%
    tibble::column_to_rownames(var = 'JEI') %>%
    rbind(rep(0, nrow(.)), .) %>%
    rbind(rep(100, nrow(.)), .)

  if(nrow(toplo) == 0)
    stop('No marine segments in id')

  plot(c(-1.2, 1.2), c(-1.2, 1.2), type = "n", frame.plot = FALSE,
       axes = FALSE, xlab = "", ylab = "", asp = 1)

  n <- ncol(toplo)
  theta <- seq(90, 450, length = n + 1) * pi/180
  theta <- theta[1:n]
  xx <- cos(theta)
  yy <- sin(theta)
  CGap <- 1
  for (i in 0:seg) {

    polygon(xx * (i + CGap)/(seg + CGap), yy * (i + CGap)/(seg + CGap), lty = 1, lwd = 1, border = cglcol)

    CAXISLABELS <- caxislabels[i + 1]

    text(-0.05, (i + CGap)/(seg + CGap), CAXISLABELS,
         col = axislabcol, cex = valsz)

  }

  arrows(xx/(seg + CGap), yy/(seg + CGap), xx * 1, yy *
           1, lwd = 1, lty = 1, length = 0, col = cglcol)

  # variable labels
  VLABELS <- colnames(toplo)
  text(xx * 1.2, yy * 1.2, VLABELS, cex = lbsz)

  # polygon and points
  xxs <- xx
  yys <- yy
  scale <- CGap/(seg + CGap) + (toplo[3, ] - toplo[2, ])/(toplo[1, ] - toplo[2, ]) * seg/(seg + CGap)

  for (j in 1:n) {
    if (is.na(toplo[3, j])) {

      left <- ifelse(j > 1, j - 1, n)
      while (is.na(toplo[3, left])) {
        left <- ifelse(left > 1, left - 1, n)
      }
      right <- ifelse(j < n, j + 1, 1)
      while (is.na(toplo[3, right])) {
        right <- ifelse(right < n, right + 1, 1)
      }
      xxleft <- xx[left] * CGap/(seg + CGap) +
        xx[left] * (toplo[3, left] - toplo[2, left])/(toplo[1,
                                                   left] - toplo[2, left]) * seg/(seg + CGap)
      yyleft <- yy[left] * CGap/(seg + CGap) +
        yy[left] * (toplo[3, left] - toplo[2, left])/(toplo[1,
                                                   left] - toplo[2, left]) * seg/(seg + CGap)
      xxright <- xx[right] * CGap/(seg + CGap) +
        xx[right] * (toplo[3, right] - toplo[2, right])/(toplo[1,
                                                      right] - toplo[2, right]) * seg/(seg +
                                                                                      CGap)
      yyright <- yy[right] * CGap/(seg + CGap) +
        yy[right] * (toplo[3, right] - toplo[2, right])/(toplo[1,
                                                      right] - toplo[2, right]) * seg/(seg +
                                                                                      CGap)
      if (xxleft > xxright) {
        xxtmp <- xxleft
        yytmp <- yyleft
        xxleft <- xxright
        yyleft <- yyright
        xxright <- xxtmp
        yyright <- yytmp
      }
      xxs[j] <- xx[j] * (yyleft * xxright - yyright *
                           xxleft)/(yy[j] * (xxright - xxleft) -
                                      xx[j] * (yyright - yyleft))
      yys[j] <- (yy[j]/xx[j]) * xxs[j]

    } else {

      xxs[j] <- xx[j] * CGap/(seg + CGap) + xx[j] *
        (toplo[3, j] - toplo[2, j])/(toplo[1, j] - toplo[2,
                                             j]) * seg/(seg + CGap)
      yys[j] <- yy[j] * CGap/(seg + CGap) + yy[j] *
        (toplo[3, j] - toplo[2, j])/(toplo[1, j] - toplo[2,
                                             j]) * seg/(seg + CGap)
    }

  }

  polygon(xxs, yys, lty = 1, lwd = brdwd, border = col, col = pfcol)
  points(xx * scale, yy * scale, pch = 16, col = col, cex = ptsz)

}

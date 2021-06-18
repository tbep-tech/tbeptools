#' Radar plots for tidal creek indicators
#'
#' Radar plots for tidal creek indicators
#'
#' @param id numeric indicating the \code{id} number of the tidal creek to plot
#' @param cntdat output from \code{\link{anlz_tdlcrkindic}}
#'
#' @return A radar plot
#' @export
#'
#' @details See details in \code{\link{anlz_tldcrkindic}} for an explanation of the indicators
#'
#' Internal code borrowed heavily from \code{\link[fmsb]{radarchart}}.
#'
#' @concept show
#'
#' @examples
#' cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018, radar = TRUE)
#' show_tdlcrkradar(35, cntdat)
show_tdlcrkradar <- function (id, cntdat, col = '#338080E6'){

  axistype <- 3
  seg <- 5
  pty <- 16
  plty <- 1
  plwd <- 5
  pdensity <- NULL
  pangle <- 45
  pfcol <- ggplot2::alpha(col, 0.4)
  cglty <- 1
  cglwd <- 1
  cglcol <- "grey"
  axislabcol <- "grey"
  title <- ""
  maxmin <- TRUE
  na.itp <- TRUE
  centerzero <- FALSE
  vlabels <- NULL
  vlcex <- 0.8
  caxislabels <- seq(0,100,20)
  calcex <- NULL
  paxislabels <- ''
  palcex <- NULL

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
       axes = FALSE, xlab = "", ylab = "", main = title, asp = 1)

  theta <- seq(90, 450, length = n + 1) * pi/180
  theta <- theta[1:n]
  xx <- cos(theta)
  yy <- sin(theta)
  CGap <- ifelse(centerzero, 0, 1)
  for (i in 0:seg) {
    polygon(xx * (i + CGap)/(seg + CGap), yy * (i + CGap)/(seg +
                                                             CGap), lty = cglty, lwd = cglwd, border = cglcol)
    if (axistype == 1 | axistype == 3)
      CAXISLABELS <- paste(i/seg * 100, "(%)")
    if (axistype == 4 | axistype == 5)
      CAXISLABELS <- sprintf("%3.2f", i/seg)
    if (!is.null(caxislabels) & (i < length(caxislabels)))
      CAXISLABELS <- caxislabels[i + 1]
    if (axistype == 1 | axistype == 3 | axistype == 4 |
        axistype == 5) {
      if (is.null(calcex))
        text(-0.05, (i + CGap)/(seg + CGap), CAXISLABELS,
             col = axislabcol)
      else text(-0.05, (i + CGap)/(seg + CGap), CAXISLABELS,
                col = axislabcol, cex = calcex)
    }
  }
  if (centerzero) {
    arrows(0, 0, xx * 1, yy * 1, lwd = cglwd, lty = cglty,
           length = 0, col = cglcol)
  }
  else {
    arrows(xx/(seg + CGap), yy/(seg + CGap), xx * 1, yy *
             1, lwd = cglwd, lty = cglty, length = 0, col = cglcol)
  }
  PAXISLABELS <- toplo[1, 1:n]
  if (!is.null(paxislabels))
    PAXISLABELS <- paxislabels
  if (axistype == 2 | axistype == 3 | axistype == 5) {
    if (is.null(palcex))
      text(xx[1:n], yy[1:n], PAXISLABELS, col = axislabcol)
    else text(xx[1:n], yy[1:n], PAXISLABELS, col = axislabcol,
              cex = palcex)
  }
  VLABELS <- colnames(toplo)
  if (!is.null(vlabels))
    VLABELS <- vlabels
  if (is.null(vlcex))
    text(xx * 1.2, yy * 1.2, VLABELS)
  else text(xx * 1.2, yy * 1.2, VLABELS, cex = vlcex)
  series <- length(toplo[[1]])
  SX <- series - 2
  if (length(pty) < SX) {
    ptys <- rep(pty, SX)
  }
  else {
    ptys <- pty
  }
  if (length(col) < SX) {
    cols <- rep(col, SX)
  }
  else {
    cols <- col
  }
  if (length(plty) < SX) {
    pltys <- rep(plty, SX)
  }
  else {
    pltys <- plty
  }
  if (length(plwd) < SX) {
    plwds <- rep(plwd, SX)
  }
  else {
    plwds <- plwd
  }
  if (length(pdensity) < SX) {
    pdensities <- rep(pdensity, SX)
  }
  else {
    pdensities <- pdensity
  }
  if (length(pangle) < SX) {
    pangles <- rep(pangle, SX)
  }
  else {
    pangles <- pangle
  }
  if (length(pfcol) < SX) {
    pfcols <- rep(pfcol, SX)
  }
  else {
    pfcols <- pfcol
  }
  for (i in 3:series) {
    xxs <- xx
    yys <- yy
    scale <- CGap/(seg + CGap) + (toplo[i, ] - toplo[2, ])/(toplo[1,
    ] - toplo[2, ]) * seg/(seg + CGap)
    if (sum(!is.na(toplo[i, ])) < 3) {
      cat(sprintf("[DATA NOT ENOUGH] at %d\n%g\n", i,
                  toplo[i, ]))
    }
    else {
      for (j in 1:n) {
        if (is.na(toplo[i, j])) {
          if (na.itp) {
            left <- ifelse(j > 1, j - 1, n)
            while (is.na(toplo[i, left])) {
              left <- ifelse(left > 1, left - 1, n)
            }
            right <- ifelse(j < n, j + 1, 1)
            while (is.na(toplo[i, right])) {
              right <- ifelse(right < n, right + 1,
                              1)
            }
            xxleft <- xx[left] * CGap/(seg + CGap) +
              xx[left] * (toplo[i, left] - toplo[2, left])/(toplo[1,
                                                         left] - toplo[2, left]) * seg/(seg + CGap)
            yyleft <- yy[left] * CGap/(seg + CGap) +
              yy[left] * (toplo[i, left] - toplo[2, left])/(toplo[1,
                                                         left] - toplo[2, left]) * seg/(seg + CGap)
            xxright <- xx[right] * CGap/(seg + CGap) +
              xx[right] * (toplo[i, right] - toplo[2, right])/(toplo[1,
                                                            right] - toplo[2, right]) * seg/(seg +
                                                                                            CGap)
            yyright <- yy[right] * CGap/(seg + CGap) +
              yy[right] * (toplo[i, right] - toplo[2, right])/(toplo[1,
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
          }
          else {
            xxs[j] <- 0
            yys[j] <- 0
          }
        }
        else {
          xxs[j] <- xx[j] * CGap/(seg + CGap) + xx[j] *
            (toplo[i, j] - toplo[2, j])/(toplo[1, j] - toplo[2,
                                                 j]) * seg/(seg + CGap)
          yys[j] <- yy[j] * CGap/(seg + CGap) + yy[j] *
            (toplo[i, j] - toplo[2, j])/(toplo[1, j] - toplo[2,
                                                 j]) * seg/(seg + CGap)
        }
      }
      if (is.null(pdensities)) {
        polygon(xxs, yys, lty = pltys[i - 2], lwd = plwds[i -
                                                            2], border = cols[i - 2], col = pfcols[i -
                                                                                                      2])
      }
      else {
        polygon(xxs, yys, lty = pltys[i - 2], lwd = plwds[i -
                                                            2], border = cols[i - 2], density = pdensities[i -
                                                                                                              2], angle = pangles[i - 2], col = pfcols[i -
                                                                                                                                                         2])
      }
      points(xx * scale, yy * scale, pch = ptys[i - 2],
             col = cols[i - 2])
    }
  }
}

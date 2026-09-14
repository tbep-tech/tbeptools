test_that("Checking show_tbniscrseas class", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscrseas(tbniscr, yr = 2018)
  expect_is(result, 'ggplot')

})

test_that("Checking show_tbniscrseas class with metric", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscrseas(tbniscr, yr = 2018, metric = 'NumTaxa')
  expect_is(result, 'ggplot')

})

test_that("Checking show_tbniscrseas plotly class", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscrseas(tbniscr, yr = 2018, plotly = TRUE)
  expect_is(result, 'plotly')

})

test_that("Checking show_tbniscrseas class with perc ignored if metric supplied", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscrseas(tbniscr, yr = 2018, metric = 'NumTaxa', perc = c(44, 34))
  expect_is(result, 'ggplot')

})

test_that("Checking show_tbniscrseas uses perc background for explicit metric = 'TBNI_Score'", {

  tbniscr <- anlz_tbniscr(fimdata)
  resdef <- show_tbniscrseas(tbniscr, yr = 2018)
  resexp <- show_tbniscrseas(tbniscr, yr = 2018, metric = 'TBNI_Score')

  nlaydef <- length(resdef$layers)
  nlayexp <- length(resexp$layers)

  expect_equal(nlaydef, nlayexp)
  expect_error(show_tbniscrseas(tbniscr, yr = 2018, metric = 'TBNI_Score', perc = c(44, 34)))

})

test_that("Checking show_tbniscrseas y-axis title includes yr, bay_segment, and metric", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscrseas(tbniscr, bay_segment = 'OTB', yr = 2018, metric = 'NumTaxa')
  expect_equal(ggplot2::get_labs(result)$y, '2018 OTB Number of Taxa')

})

test_that("Checking show_tbniscrseas plotly point tooltip shows station", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscrseas(tbniscr, yr = 2018, plotly = TRUE)
  pb <- plotly::plotly_build(result)
  istext <- sapply(pb$x$data, function(x) !is.null(x$mode) && grepl('markers', x$mode) && !is.null(x$text))
  expect_true(any(istext))

})

test_that("Checking show_tbniscrseas sanity checks", {

  tbniscr <- anlz_tbniscr(fimdata)

  expect_error(show_tbniscrseas(tbniscr))
  expect_error(show_tbniscrseas(tbniscr, yr = 1900))
  expect_error(show_tbniscrseas(tbniscr, yr = 2018, metric = 'notacolumn'))
  expect_error(show_tbniscrseas(tbniscr, bay_segment = c('OTB', 'HB'), yr = 2018))
  expect_error(show_tbniscrseas(tbniscr, yr = 2018, perc = c(20, 54)))
  expect_error(show_tbniscrseas(tbniscr, yr = 2018, perc = c(25, 65)))
  expect_error(show_tbniscrseas(tbniscr, yr = 2018, perc = 44))
  expect_error(show_tbniscrseas(tbniscr, yr = 2018, perc = c(44, 34)))

})

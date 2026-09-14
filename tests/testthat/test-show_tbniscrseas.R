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

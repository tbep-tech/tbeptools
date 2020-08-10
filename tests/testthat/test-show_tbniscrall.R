test_that("Checking show_tbniscrall class", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscrall(tbniscr)
  expect_is(result, 'ggplot')

})

test_that("Checking show_tbniscrall plotly class", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscrall(tbniscr, plotly = TRUE)
  expect_is(result, 'plotly')

})

test_that("Checking show_tbniscrall sanity checks", {

  expect_error(show_tbniscrall(NULL, perc = c(20, 54)))
  expect_error(show_tbniscrall(NULL, perc = c(25, 65)))
  expect_error(show_tbniscrall(NULL, perc = 44))
  expect_error(show_tbniscrall(NULL, perc = c(44, 34)))

})

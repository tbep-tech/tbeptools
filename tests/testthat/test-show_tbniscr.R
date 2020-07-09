test_that("Checking show_tbniscr class", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscr(tbniscr)
  expect_is(result, 'ggplot')

})

test_that("Checking show_tbniscr plotly class", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbniscr(tbniscr, plotly = TRUE)
  expect_is(result, 'plotly')

})

test_that("Checking show_tbniscr sanity checks", {

  expect_error(show_tbniscr(NULL, perc = c(20, 54)))
  expect_error(show_tbniscr(NULL, perc = c(25, 65)))
  expect_error(show_tbniscr(NULL, perc = 44))
  expect_error(show_tbniscr(NULL, perc = c(44, 34)))

})

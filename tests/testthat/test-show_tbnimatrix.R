test_that("Checking show_tbnimatrix class", {

  tbniscr <- anlz_tbniscr(fimdata)
  result <- show_tbnimatrix(tbniscr)
  expect_is(result, 'ggplot')

})

test_that("Checking show_tbnimatrix sanity checks", {

  expect_error(show_tbnimatrix(NULL, perc = c(20, 54)))
  expect_error(show_tbnimatrix(NULL, perc = c(25, 65)))
  expect_error(show_tbnimatrix(NULL, perc = 44))
  expect_error(show_tbnimatrix(NULL, perc = c(44, 34)))

})

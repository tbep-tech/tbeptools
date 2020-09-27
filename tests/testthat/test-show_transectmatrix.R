test_that("Checking show_transectmatrix class", {

  transectocc <- anlz_transectocc(transect)
  result <- show_transectmatrix(transectocc)
  expect_is(result, 'ggplot')

})

test_that("Checking show_transectmatrix sanity checks", {

  expect_error(show_transectmatrix(NULL, yrrng = 1998))
  expect_error(show_transectmatrix(NULL, yrrng = c(2009, 1997)))

})

test_that("Checking show_transectmatrix plotly class", {

  transectocc <- anlz_transectocc(transect)
  result <- show_transectmatrix(transectocc, plotly = T)
  expect_is(result, 'plotly')

})

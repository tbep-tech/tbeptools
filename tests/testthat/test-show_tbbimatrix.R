test_that("Checking show_tbbimatrix class", {

  tbbiscr <- anlz_tbbiscr(benthicdata)
  result <- show_tbbimatrix(tbbiscr)
  expect_is(result, 'ggplot')

})

test_that("Checking show_tbbimatrix sanity checks", {

  expect_error(show_tbbimatrix(NULL, yrrng = 1998))
  expect_error(show_tbbimatrix(NULL, yrrng = c(2009, 1997)))

})

test_that("Checking show_tbbimatrix plotly class", {

  tbbiscr <- anlz_tbbiscr(benthicdata)
  result <- show_tbbimatrix(tbbiscr, plotly = T)
  expect_is(result, 'plotly')

})

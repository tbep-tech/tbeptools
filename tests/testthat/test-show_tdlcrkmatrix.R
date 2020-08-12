dat <- anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2018)
test_that("Checking show_tdlcrkmatrix class", {
  result <- show_tdlcrkmatrix(dat)
  expect_is(result, 'ggplot')
})
test_that("Checking show_tdlcrkmatrix class argument", {
  expect_error(show_tdlcrkmatrix(dat, class = 'asdf'))
})
test_that("Checking show_tdlcrkmatrix score argument", {
  expect_error(show_tdlcrkmatrix(dat, score = 'asdf'))
})

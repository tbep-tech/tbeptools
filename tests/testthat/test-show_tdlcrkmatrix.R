test_that("Checking show_tdlcrkmatrix class", {
  result <- show_tdlcrkmatrix(tdldat)
  expect_is(result, 'ggplot')
})
test_that("Checking show_tdlcrkmatrix class argument", {
  expect_error(show_tdlcrkmatrix(tdldat, class = 'asdf'))
})
test_that("Checking show_tdlcrkmatrix score argument", {
  expect_error(show_tdlcrkmatrix(tdldat, score = 'asdf'))
})

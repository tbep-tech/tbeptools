test_that("Checking show_hmpreport class, type as targets", {

  result <- show_hmpreport(acres, subtacres, hmptrgs, typ = 'targets')
  expect_is(result, 'ggplot')

})

test_that("Checking show_hmpreport class, type as goals", {

  result <- show_hmpreport(acres, subtacres, hmptrgs, typ = 'goals', totintertid = F)
  expect_is(result, 'ggplot')

})

test_that("Checking show_hmpreport class, ycollapse = T", {

  result <- show_hmpreport(acres, subtacres, hmptrgs, typ = 'targets', ycollapse = T)
  expect_is(result, 'ggplot')

})

test_that("Checking show_hmpreport class, twocol = T", {

  result <- show_hmpreport(acres, subtacres, hmptrgs, typ = 'targets', twocol = T)
  expect_is(result, 'ggplot')

})

test_that("Checking error if text is NULL when twocol = T", {

  expect_error(show_hmpreport(acres, subtacres, hmptrgs, typ = 'targets', twocol = T, text = NULL),
               "text value as numeric must be provided when twocol = TRUE")

})

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

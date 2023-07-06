test_that("Checking show_hmpreport class, type as targets", {

  result <- show_hmpreport(acres, subtacres, hmptrgs, typ = 'targets')
  expect_is(result, 'ggplot')

})

test_that("Checking show_hmpreport class, type as goals", {

  result <- show_hmpreport(acres, subtacres, hmptrgs, typ = 'goals')
  expect_is(result, 'ggplot')

})

test_that("Checking show_hmpreport class, plotly output", {

  result <- show_hmpreport(acres, subtacres, hmptrgs, typ = 'goals', plotly = T)
  expect_is(result, 'plotly')

})

test_that("Checking show_hmpreport class, combined = F", {

  result <- expect_warning(show_hmpreport(acres, subtacres, hmptrgs, typ = 'targets', combined = F, plotly = T))
  expect_is(result, 'ggplot')

})

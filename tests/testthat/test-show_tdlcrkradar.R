test_that("Checking show_tdlcrkradar class", {

  result <- show_tdlcrkradar(494, cntdat)
  expect_is(result, 'ggplot')

})

test_that("Checking show_tdlcrkradar no data", {

  expect_message(show_tdlcrkradar(495, cntdat), 'No marine segments in id')

})

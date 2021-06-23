test_that("Checking show_tdlcrkradar class", {

  result <- show_tdlcrkradar(494, cntdat)
  expect_is(result, 'NULL')

})

test_that("Checking show_tdlcrkradar no data", {

  expect_error(show_tdlcrkradar(495, cntdat))

})

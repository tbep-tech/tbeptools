test_that("Checking show_tdlcrkradar class", {

  result <- show_tdlcrkradar(1, cntdatrdr)
  expect_is(result, 'NULL')

})

test_that("Checking show_tdlcrkradar no data", {

  expect_error(show_tdlcrkradar(12, cntdatrdr))

})

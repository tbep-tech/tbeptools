test_that("Checking show_tdlcrkradar class", {
  id <- cntdatrdr$id[1]
  result <- show_tdlcrkradar(id, cntdatrdr)
  expect_is(result, 'NULL')

})

test_that("Checking show_tdlcrkradar no data", {

  expect_error(show_tdlcrkradar('xxxxxx', cntdatrdr))

})

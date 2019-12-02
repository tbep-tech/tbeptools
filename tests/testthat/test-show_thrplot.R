test_that("Checking show_thrplot class", {
  result <- show_thrplot(epcdata)
  expect_is(result, 'ggplot')
})
test_that("Checking show_thrplot bay_segment",{
  expect_error(show_thrplot(epcdata, bay_segment = "lll"), "'arg' should be one of “OTB”, “HB”, “MTB”, “LTB”")
})

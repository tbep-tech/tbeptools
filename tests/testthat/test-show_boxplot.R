test_that("Checking show_boxplot class", {
  result <- show_boxplot(epcdata)
  expect_is(result, 'ggplot')
})
test_that("Checking show_boxplot bay_segment",{
  expect_error(show_boxplot(epcdata, bay_segment = "lll"), "'arg' should be one of “OTB”, “HB”, “MTB”, “LTB”")
})

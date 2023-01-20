test_that("Checking show_sedimentpelave class", {
  result <- show_sedimentpelave(sedimentdata, yrrng = 2021)
  expect_is(result, 'ggplot')
})

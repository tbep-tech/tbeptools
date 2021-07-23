test_that("Checking show_compplot", {

  transect <- read_transect(training = T)

  result <- show_compplot(transect, yr = 2020, site = '1')

  expect_is(result, 'ggplot')

  result <- show_compplot(transect, yr = 2020, site = '1', varplo = 'Blade Length')

  expect_is(result, 'ggplot')

})

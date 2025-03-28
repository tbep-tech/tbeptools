test_that("Checking show_boxplot class, partial year", {
  result <- show_boxplot(epcdata, partialyr = T)
  expect_is(result, 'ggplot')
})

test_that("Checking show_boxplot error for year order", {
  expect_error(show_boxplot(epcdata, yrrng = c(2008, 2007)))
})

test_that("Checking show_boxplot error for year value outside of range", {
  expect_error(show_boxplot(epcdata, yrrng = c(1900, 2007)))
})

test_that("Checking show_boxplot labelexp = F", {
  result <- show_boxplot(epcdata, labelexp = F)
  expect_is(result, 'ggplot')
})

test_that("Checking show_boxplot year selection not in data range", {
  expect_error(show_boxplot(epcdata, labelexp = F, yrsel = 1900))
})

test_that("Checking show_boxplot points = F", {
  result <- show_boxplot(epcdata, points = F)
  expect_is(result, 'ggplot')
})

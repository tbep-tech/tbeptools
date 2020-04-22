test_that("Checking show_boxplot class", {
  result <- show_boxplot(epcdata)
  expect_is(result, 'ggplot')
})

test_that("Checking show_boxplot error for year order", {
  expect_error(show_boxplot(epcdata, yrrng = c(2008, 2007)))
})

test_that("Checking show_boxplot error for year value outside or range", {
  expect_error(show_boxplot(epcdata, yrrng = c(1900, 2007)))
})

test_that("Checking show_boxplot labelexp = F", {
  result <- show_boxplot(epcdata, labelexp = F)
  expect_is(result, 'ggplot')
})

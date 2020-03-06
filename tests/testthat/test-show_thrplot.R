test_that("Checking show_thrplot class", {
  result <- show_thrplot(epcdata)
  expect_is(result, 'ggplot')
})

test_that("Checking show_thrplot error", {
  expect_error(show_thrplot(epcdata, yrrng = c(2008, 2007)))
})

test_that("Checking show_thrplot labelexp = F", {
  result <- show_thrplot(epcdata, labelexp = F)
  expect_is(result, 'ggplot')
})

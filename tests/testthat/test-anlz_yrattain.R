test_that("Checking anlz_yrattain 2018", {
  result <- anlz_yrattain(epcdata, 2018) %>%
    pull(outcome)
  expect_equal(c('yellow', 'green', 'green', 'green'), result)
})
test_that("Checking anlz_yrattain 1984", {
  result <- anlz_yrattain(epcdata, 1984) %>%
    pull(outcome)
  expect_equal(c('red', 'green', 'red', 'yellow'), result)
})


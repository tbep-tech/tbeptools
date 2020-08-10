test_that("Checking anlz_attainsite", {
  result <- anlz_avedatsite(epcdata) %>%
    anlz_attainsite %>%
    pull(met) %>%
    .[c(1, 11)]
  expect_equal(c('no', 'no'), result)
})

test_that("Checking anlz_attainsite, thrs = T", {
  result <- anlz_avedatsite(epcdata) %>%
    anlz_attainsite(thrs = T) %>%
    pull(met) %>%
    .[c(1, 11)]
  expect_equal(c('no', 'no'), result)
})



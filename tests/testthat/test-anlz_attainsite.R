test_that("Checking anlz_attainsite", {
  result <- anlz_avedatsite(epcdata) %>%
    anlz_attainsite %>%
    pull(trgtmet) %>%
    .[c(1, 11)]
  expect_equal(c('no', 'yes'), result)
})

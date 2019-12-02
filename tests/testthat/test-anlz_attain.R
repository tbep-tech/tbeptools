test_that("Checking anlz_attain", {
  result <- anlz_avedat(epcdata) %>%
    anlz_attain %>%
    pull(chl_la) %>%
    .[1:4]
  expect_equal(c('2_0', '2_2', '2_2', '3_2'), result)
})

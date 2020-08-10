test_that("Checking anlz_avedatsite months", {
  result <- anlz_avedatsite(epcdata) %>%
    .[['mos']] %>%
    pull(val) %>%
    .[1:4]
  expect_equal(c(53, 19, 46, 24), result)
})
test_that("Checking anlz_avedatsite years", {
  result <- anlz_avedatsite(epcdata) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[1:4] %>%
    round(5)
  expect_equal(c(25.59091, 21.63636, 22.63636, 23.40909), result)
})

test_that("Checking anlz_avedatsite, partial year", {
  result <- anlz_avedatsite(epcdata, partialyr = T) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[1:4] %>%
    round(5)
  expect_equal(c(25.59091, 21.63636, 22.63636, 23.40909), result)
})

test_that("Checking anlz_tldcrk", {

  result <- anlz_tdlcrk(tidalcreeks, iwrraw, yr= 2018) %>%
    pull(score) %>%
    .[1:4]

  expect_equal(result, c("No Data", "No Data", "Green", "Green"))

})

test_that("Checking anlz_iwrraw", {

  result <- anlz_iwrraw(iwrraw, tidalcreeks, yr = 2018) %>%
    pull(masterCode) %>%
    unique
  expect_equal(result, c("COND", "SALIN", "COLOR", "DO", "DOSAT", "NO23", "ORGN", "TN",
                         "TP", "CHLAC", "TKN", "TSS", "TURB"))

})

test_that("Checking correct parameter codes in anlz_iwrraw", {

  result <- anlz_iwrraw(iwrraw, tidalcreeks, yr = 2024) %>%
    pull(masterCode) %>%
    unique

  chk <- any(!result %in% c("COND", "SALIN", "COLOR", "DO", "DOSAT", "NO23", "ORGN", "TN",
                           "TP", "CHLAC", "TKN", "TURB", "TSS"))

  expect_false(chk)

})

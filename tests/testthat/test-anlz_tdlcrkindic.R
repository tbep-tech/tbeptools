test_that("Checking anlz_tdlcrkindic", {

  result <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018) %>%
    .[nrow(.), ]

  expect_equal(result, structure(list(id = NA_integer_, wbid = NA_character_, JEI = "LC02",
                                      name = NA_character_, class = NA_character_, year = 2014,
                                      CHLAC = NA_real_, COLOR = NA_real_, COND = NA_real_, DO = NA_real_,
                                      DOSAT = NA_real_, NO23 = NA_real_, ORGN = NA_real_, SALIN = NA_real_,
                                      TKN = NA_real_, TN = NA_real_, TP = NA_real_, TSS = NA_real_,
                                      TURB = NA_real_, chla_tn_ratio = NA_real_, tn_tp_ratio = NA_real_,
                                      chla_tsi = NA_real_, tn_tsi = NA_real_, tn2_tsi = NA_real_,
                                      tp_tsi = NA_real_, tp2_tsi = NA_real_, nut_tsi = NA_real_,
                                      tsi = NA_real_, no23_ratio = 1.84210526315789), row.names = 1027L, class = "data.frame"))

})


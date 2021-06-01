test_that("Checking anlz_tdlcrkindic", {

  result <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018) %>%
    .[nrow(.), ]

  expect_equal(result, structure(list(id = 572L, wbid = "1976", JEI = "SC40", name = "Big Slough Canal",
                                      class = "1", year = 2008, CHLAC = NA_real_, COLOR = NA_real_,
                                      COND = 459, DO = NA_real_, DOSAT = NA_real_, NO23 = NA_real_,
                                      ORGN = NA_real_, SALIN = NA_real_, TKN = NA_real_, TN = NA_real_,
                                      TP = NA_real_, TSS = NA_real_, TURB = NA_real_, chla_tn_ratio = NA_real_,
                                      tn_tp_ratio = NA_real_, chla_tsi = NA_real_, tn_tsi = NA_real_,
                                      tn2_tsi = NA_real_, tp_tsi = NA_real_, tp2_tsi = NA_real_,
                                      nut_tsi = NaN, tsi = NaN, no23_source = NA_real_, no23_tidal = NA_real_,
                                      no23_ratio = NA_real_, do_bnml = NA_real_, do_prop = NA_real_), row.names = 1144L, class = "data.frame"))

})


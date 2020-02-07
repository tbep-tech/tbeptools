test_that("Checking anlz_tdlcrkindic", {

  result <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018) %>%
    .[nrow(.), ]

  expect_equal(result, structure(list(id = 565L, wbid = "2026", JEI = "SC37", class = "3M",
                                      year = 2008, CHLAC = 2.80886253685455, COLOR = NA_real_,
                                      COND = 25361.95004897, DO = 2.19875339132418, DOSAT = 27.4890362838677,
                                      NO23 = 0.0259680358062411, ORGN = NA_real_, SALIN = 15.4206629191757,
                                      TKN = 0.659814567759305, TN = 0.693137546997186, TP = 0.0304139957907973,
                                      TSS = 4.58114078563817, TURB = 1.34968226305967, chla_tn_ratio = 4.05238837374072,
                                      tn_tp_ratio = 22.7900849255367, chla_tsi = 31.6720263874652,
                                      tn_tsi = 48.742768984365, tn2_tsi = 51.7227750058298, tp_tsi = 45.1171937599776,
                                      tp2_tsi = 56.7917082115845, nut_tsi = 46.9299813721713, tsi = 39.3010038798182), row.names = 1028L, class = "data.frame"))
})

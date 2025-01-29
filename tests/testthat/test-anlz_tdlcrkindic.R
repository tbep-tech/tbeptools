test_that("Checking anlz_tdlcrkindic", {

  result <- cntdat %>%
    .[1, ]

  expect_equal(result, structure(list(id = 1L, name = "Rock Creek", JEI = "CC01", wbid = "1983B",
                                      class = "2", year = 2022, CHLAC = NA_real_, COLOR = NA_real_,
                                      COND = 53297.2458825032, DO = 4.15989182551662, DOSAT = 66.5484785701371,
                                      NO23 = 0.006, ORGN = NA_real_, SALIN = 35.1849968026146,
                                      TKN = 0.626, TN = 0.626, TP = 0.065, TSS = 45.3, TURB = 2.3,
                                      chla_tn_ratio = NA_real_, tn_tp_ratio = 9.63076923076923,
                                      chla_tsi = NA_real_, tn_tsi = 46.7255828239356, tn2_tsi = 49.5327287110362,
                                      tp_tsi = 59.2436032200589, tp2_tsi = 74.715539569537, nut_tsi = 49.5327287110362,
                                      tsi = NA_real_, no23_source = NA_real_, no23_tidal = NA_real_,
                                      no23_ratio = NA_real_, do_bnml = 0, do_prop = 0), row.names = 1L, class = "data.frame"))

})


test_that("Checking anlz_tdlcrkindic radar plot output", {

  result <- cntdatrdr %>%
    .[1:6, ]

  expect_equal(result, structure(list(id = c(1L, 1L, 1L, 1L, 1L, 1L),
                                      JEI = c("CC01", "CC01", "CC01", "CC01", "CC01", "CC01"),
                                      wbid = c("1983B", "1983B", "1983B", "1983B", "1983B", "1983B"),
                                      var = c("ch_tn_rat_ind", "chla_ind", "do_prop", "nox_ind", "tn_ind", "tsi_ind"),
                                      val = c(NaN, NaN, 0, NaN, 0, NaN)),
                                      row.names = c(NA, -6L), class = c("tbl_df", "tbl", "data.frame")))

})



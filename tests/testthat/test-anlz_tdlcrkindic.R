test_that("Checking anlz_tdlcrkindic", {

  result <- cntdat %>%
    .[1, ]

  expect_equal(result, structure(list(id = 2L, name = "Rock Creek", JEI = "CC01", wbid = "2052",
                                      class = "3M", year = 2014, CHLAC = 2.38024893606106, COLOR = 14.6947349082311,
                                      COND = NA_real_, DO = 3.30828942140491, DOSAT = 60.3152311067264,
                                      NO23 = 0.00757579181535898, ORGN = NA_real_, SALIN = 26.6371421584727,
                                      TKN = 0.61617022585426, TN = 0.622878244133144, TP = 0.0693814983072397,
                                      TSS = NA_real_, TURB = 2.04462277641478, chla_tn_ratio = 3.82137112426144,
                                      tn_tp_ratio = 8.97758421668662, chla_tsi = 29.2877531116418,
                                      tn_tsi = 46.6265965613584, tn2_tsi = 49.4252608383106, tp_tsi = 60.4569364077062,
                                      tp2_tsi = 76.2550375925734, nut_tsi = 49.4252608383106, tsi = 39.3565069749762,
                                      no23_source = NA_real_, no23_tidal = NA_real_, no23_ratio = NA_real_,
                                      do_bnml = 0, do_prop = 1), row.names = 1L, class = "data.frame"))

})


test_that("Checking anlz_tdlcrkindic radar plot output", {

  result <- cntdatrdr %>%
    .[1:6, ]

  expect_equal(result, structure(list(id = c(2L, 2L, 2L, 2L, 2L, 2L),
                                      JEI = c("CC01", "CC01", "CC01", "CC01", "CC01", "CC01"),
                                      wbid = c("2052", "2052", "2052", "2052", "2052", "2052"),
                                      var = c("ch_tn_rat_ind", "chla_ind", "do_prop", "nox_ind", "tn_ind", "tsi_ind"),
                                      val = c(0, 0, 80, NaN, 0, 0)),
                                      row.names = c(NA, -6L), class = c("tbl_df", "tbl", "data.frame")))

})



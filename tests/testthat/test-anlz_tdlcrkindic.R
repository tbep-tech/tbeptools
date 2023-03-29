test_that("Checking anlz_tdlcrkindic", {

  result <- cntdat %>%
    .[1, ]

  expect_equal(result, structure(list(id = 2L, name = "Rock Creek", JEI = "CC01", wbid = "2052",
                                      class = "3M", year = 2012, CHLAC = 2.28122712003548, COLOR = 15.1594080580585,
                                      COND = NA_real_, DO = 2.8, DOSAT = 48.4875522361945, NO23 = 0.00974297278665924,
                                      ORGN = NA_real_, SALIN = 26.4984278015125, TKN = 0.670790128383257,
                                      TN = 0.680309511379557, TP = 0.067628313972869, TSS = NA_real_,
                                      TURB = 2.08502806090103, chla_tn_ratio = 3.35321950064982,
                                      tn_tp_ratio = 10.0595367740867, chla_tsi = 28.6758745256383,
                                      tn_tsi = 48.3728930726321, tn2_tsi = 51.3212005516474, tp_tsi = 59.9808973846464,
                                      tp2_tsi = 75.6510310901965, nut_tsi = 54.1768952286393, tsi = 41.4263848771388,
                                      no23_source = NA_real_, no23_tidal = NA_real_, no23_ratio = NA_real_,
                                      do_bnml = 1, do_prop = 1), row.names = 1L, class = "data.frame"))

})


test_that("Checking anlz_tdlcrkindic radar plot output", {

  result <- cntdatrdr %>%
    .[1:6, ]

  expect_equal(result, structure(list(id = c(2L, 2L, 2L, 2L, 2L, 2L),
                                      JEI = c("CC01", "CC01", "CC01", "CC01", "CC01", "CC01"),
                                      wbid = c("2052", "2052", "2052", "2052", "2052", "2052"),
                                      var = c("ch_tn_rat_ind", "chla_ind", "do_prop", "nox_ind", "tn_ind", "tsi_ind"),
                                      val = c(0, 0, 70, NaN, 0, 0)),
                                      row.names = c(NA, -6L), class = c("tbl_df", "tbl", "data.frame")))

})



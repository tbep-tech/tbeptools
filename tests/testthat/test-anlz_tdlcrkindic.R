test_that("Checking anlz_tdlcrkindic", {

  result <- cntdat %>%
    .[1, ]

  expect_equal(result, structure(list(id = 2L, name = "Rock Creek", JEI = "CC01", wbid = "2052",
                                      class = "3M", year = 2013, CHLAC = 2.72539079023686, COLOR = 9.60736766005523,
                                      COND = NA_real_, DO = 6.81909084849293, DOSAT = 73.5077043152662,
                                      NO23 = 0.00978163270158512, ORGN = NA_real_, SALIN = 30.9056051708772,
                                      TKN = 0.651057463896008, TN = 0.710814571149812, TP = 0.0684281130218657,
                                      TSS = NA_real_, TURB = 1.69800431722003, chla_tn_ratio = 3.83417968743701,
                                      tn_tp_ratio = 10.3877564316683, chla_tsi = 31.2376103101581,
                                      tn_tsi = 49.241395071378, tn2_tsi = 52.2641352959144, tp_tsi = 60.1995777365896,
                                      tp2_tsi = 75.9284964829846, nut_tsi = 54.7204864039838, tsi = 42.979048357071,
                                      no23_source = NA_real_, no23_tidal = NA_real_, no23_ratio = NA_real_,
                                      do_bnml = 0, do_prop = 0), row.names = 1L, class = "data.frame"))

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



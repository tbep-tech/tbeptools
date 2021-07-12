test_that("Checking anlz_tdlcrkindic", {

  result <- cntdat %>%
    .[nrow(.), ]

  expect_equal(result, structure(list(id = 613L, name = "Rattlesnake Creek", JEI = "PC37",
                                      wbid = "1614", class = "3F", year = 2020, CHLAC = 3.85550669650914,
                                      COLOR = 60, COND = 726.210255359237, DO = 8.36584697988958,
                                      DOSAT = 101.663049835659, NO23 = 1.09929447365768, ORGN = NA_real_,
                                      SALIN = 0.352549518241804, TKN = 0.836353264650689, TN = 1.93748348937306,
                                      TP = 0.192318704284877, TSS = 1.81712059283214, TURB = 2.15985552391405,
                                      chla_tn_ratio = 1.9899558977696, tn_tp_ratio = 10.0743372652049,
                                      chla_tsi = 36.2328350951205, tn_tsi = 69.095521219784, tn2_tsi = 73.8209938110351,
                                      tp_tsi = 79.4202628010825, tp2_tsi = 100.316032371266, nut_tsi = 74.2578920104332,
                                      tsi = 55.2453635527769, no23_source = NA_real_, no23_tidal = NA_real_,
                                      no23_ratio = NA_real_, do_bnml = 0, do_prop = 0), row.names = 1669L, class = "data.frame"))

})


test_that("Checking anlz_tdlcrkindic radar plot output", {

  result <- cntdatrdr %>%
    .[c((nrow(.) - 5):nrow(.)), ]

  expect_equal(result, structure(list(id = c(612L, 612L, 612L, 612L, 612L, 612L),
                                      JEI = c("PC37", "PC37", "PC37", "PC37", "PC37", "PC37"),
                                      wbid = c("1528", "1528", "1528", "1528", "1528", "1528"),
                                      var = c("ch_tn_rat_ind", "chla_ind", "do_prop", "nox_ind", "tn_ind", "tsi_ind"),
                                      val = c(0, 0, 0, NaN, 0, 0)),
                                 row.names = c(NA, -6L), class = c("tbl_df", "tbl", "data.frame")))

})



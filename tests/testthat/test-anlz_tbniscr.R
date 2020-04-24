test_that("Checking anlz_tbniscr", {

  tbniscr <- anlz_tbniscr(fimdat)

  result <- tbniscr[nrow(tbniscr), ]
  expect_equal(result, structure(list(Reference = "TBM2018121305", Year = 2018, Month = 12,
                                      Season = "Winter", bay_segment = "LTB", TBNI_Score = 14,
                                      NumTaxa = 1, ScoreNumTaxa = 1, BenthicTaxa = 1, ScoreBenthicTaxa = 1,
                                      TaxaSelect = 1, ScoreTaxaSelect = 3, NumGuilds = 1, ScoreNumGuilds = 2,
                                      Shannon = 0, ScoreShannon = 0), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                                        "tbl", "data.frame")))

})

test_that("Checking anlz_tbniscr, raw = F", {

  tbniscr <- anlz_tbniscr(fimdat, raw = F)

  result <- tbniscr[nrow(tbniscr), ]
  expect_equal(result, structure(list(Reference = "TBM2018121305", Year = 2018, Month = 12,
                                      Season = "Winter", bay_segment = "LTB", TBNI_Score = 14,
                                      ScoreNumTaxa = 1, ScoreBenthicTaxa = 1, ScoreTaxaSelect = 3,
                                      ScoreNumGuilds = 2, ScoreShannon = 0), row.names = c(NA,
                                                                                           -1L), class = c("tbl_df", "tbl", "data.frame")))

})


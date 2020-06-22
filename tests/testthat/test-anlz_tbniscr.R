test_that("Checking anlz_tbniscr", {

  tbniscr <- anlz_tbniscr(fimdata)

  result <- tbniscr[nrow(tbniscr), ]
  expect_equal(result, structure(list(Reference = "TBM2019121309", Year = 2019, Month = 12,
                                      Season = "Winter", bay_segment = "MTB", TBNI_Score = 38,
                                      NumTaxa = 5, ScoreNumTaxa = 5, BenthicTaxa = 5, ScoreBenthicTaxa = 5,
                                      TaxaSelect = 0, ScoreTaxaSelect = 0, NumGuilds = 2, ScoreNumGuilds = 5,
                                      Shannon = 0.727591345714938, ScoreShannon = 4), row.names = c(NA,
                                                                                                    -1L), class = c("tbl_df", "tbl", "data.frame"))
  )

})

test_that("Checking anlz_tbniscr, raw = F", {

  tbniscr <- anlz_tbniscr(fimdata, raw = F)

  result <- tbniscr[nrow(tbniscr), ]
  expect_equal(result, structure(list(Reference = "TBM2019121309", Year = 2019, Month = 12,
                                      Season = "Winter", bay_segment = "MTB", TBNI_Score = 38,
                                      ScoreNumTaxa = 5, ScoreBenthicTaxa = 5, ScoreTaxaSelect = 0,
                                      ScoreNumGuilds = 5, ScoreShannon = 4), row.names = c(NA,
                                                                                           -1L), class = c("tbl_df", "tbl", "data.frame"))
  )

})


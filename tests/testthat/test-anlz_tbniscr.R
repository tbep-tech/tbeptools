test_that("Checking anlz_tbniscr", {

  tbniscr <- anlz_tbniscr(fimdata)

  result <- tbniscr[1, ]
  expect_equal(result, structure(list(Reference = "TBM1998010906", Year = 1998, Month = 1,
                                      Season = "Winter", bay_segment = "OTB", TBNI_Score = 18,
                                      NumTaxa = 2, ScoreNumTaxa = 2, BenthicTaxa = 0, ScoreBenthicTaxa = 0,
                                      TaxaSelect = 0, ScoreTaxaSelect = 0, NumGuilds = 2, ScoreNumGuilds = 5,
                                      Shannon = 0.362210557135449, ScoreShannon = 2), row.names = c(NA,
                                                                                                    -1L), class = c("tbl_df", "tbl", "data.frame"))
  )

})

test_that("Checking anlz_tbniscr, raw = F", {

  tbniscr <- anlz_tbniscr(fimdata, raw = F)

  result <- tbniscr[1, ]
  expect_equal(result, structure(list(Reference = "TBM1998010906", Year = 1998, Month = 1,
                                      Season = "Winter", bay_segment = "OTB", TBNI_Score = 18,
                                      ScoreNumTaxa = 2, ScoreBenthicTaxa = 0, ScoreTaxaSelect = 0,
                                      ScoreNumGuilds = 5, ScoreShannon = 2), row.names = c(NA,
                                                                                           -1L), class = c("tbl_df", "tbl", "data.frame"))
  )

})


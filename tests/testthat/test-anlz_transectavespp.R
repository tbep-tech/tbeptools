transectocc <- anlz_transectocc(transect)

test_that("Checking anlz_transectavespp sanity checks", {

  expect_error(anlz_transectavespp(NULL, yrrng = 1998))
  expect_error(anlz_transectavespp(NULL, yrrng = c(2009, 1997)))
  expect_error(anlz_transectavespp(NULL,bay_segment = 'xyz'))
  expect_error(anlz_transectavespp(NULL, species = 'xyz'))

})

test_that("Checking results for anlz_transectavespp", {

  results <- anlz_transectavespp(transectocc)
  results <- results[1, ]
  expect_equal(results, structure(list(yr = 1998, Savspecies = structure(6L, .Label = c("Halodule",
                                                                                        "Syringodium", "Thalassia", "Ruppia", "Halophila spp.", "Caulerpa spp."
  ), class = "factor"), foest = 0.0173992673992674), row.names = c(NA,
                                                                   -1L), class = c("tbl_df", "tbl", "data.frame")))
})

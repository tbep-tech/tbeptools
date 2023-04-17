test_that("Checking anlz_transectavespp sanity checks", {

  expect_error(anlz_transectavespp(NULL, yrrng = 1998))
  expect_error(anlz_transectavespp(NULL, yrrng = c(2009, 1997)))
  expect_error(anlz_transectavespp(NULL,bay_segment = 'xyz'))
  expect_error(anlz_transectavespp(NULL, species = 'xyz'))

})

test_that("Checking results for anlz_transectavespp", {

  results <- anlz_transectavespp(transectocc)
  results <- results[1, ]
  expect_equal(results, structure(list(yr = 1998, Savspecies = structure(7L, .Label = c("total",
                                                                                        "Halodule", "Syringodium", "Thalassia", "Ruppia", "Halophila",
                                                                                        "Caulerpa"), class = "factor"), foest = 0.0166083916083916), row.names = c(NA,
                                                                                                                                                                   -1L), class = c("tbl_df", "tbl", "data.frame")))
})

test_that("Checking results for anlz_transectavespp by segment", {

  results <- anlz_transectavespp(transectocc, by_seg = T)
  results <- results[1, ]
  expect_equal(results, structure(list(yr = 1998, bay_segment = structure(5L, .Label = c("OTB",
                                                                                         "HB", "MTB", "LTB", "BCB"), class = "factor"), Savspecies = structure(8L, .Label = c("No Cover",
                                                                                                                                                                              "total", "Halodule", "Syringodium", "Thalassia", "Ruppia", "Halophila",
                                                                                                                                                                              "Caulerpa"), class = "factor"), foest = 0, nsites = 96L), row.names = c(NA,
                                                                                                                                                                                                                                                      -1L), class = c("tbl_df", "tbl", "data.frame")))
})

test_that("Checking results for anlz_transectavespp, total FALSE", {

  results <- anlz_transectavespp(transectocc, total = F)
  expect_is(results, 'tbl_df')

})

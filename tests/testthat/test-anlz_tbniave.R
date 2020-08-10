test_that("Checking anlz_tbniave", {

  tbniscr <- anlz_tbniscr(fimdata)
  tbniave <- anlz_tbniave(tbniscr, rev = T)
  result <- tbniave$Segment_TBNI[1:5]
  expect_equal(result, c(47, 47, 44, 44, 39))

})

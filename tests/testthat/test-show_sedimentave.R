test_that("Checking show_sedimentave class", {
  result <- show_sedimentave(sedimentdata, param = 'Arsenic', yrrng = 2021)
  expect_is(result, 'ggplot')
})

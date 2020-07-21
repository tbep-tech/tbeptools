test_that("Checking show_compplot", {

  trnjsn <- read_trnjsn(training = T)
  dat<- anlz_trnjsn(trnjsn, training = T)

  result <- show_compplot(dat, site = '1')

  expect_is(result, 'ggplot')

  result <- show_compplot(dat, site = '1', varplo = 'Blade Length')

  expect_is(result, 'ggplot')

})

test_that("util_fiblevs returns list", {
  expect_type(util_fiblevs(), 'list')
  expect_equal(names(util_fiblevs()), c('ecolilev', 'ecolilbs', 'enterolev', 'enterolbs', 'fibmatlev', 'fibmatlbs'))
})

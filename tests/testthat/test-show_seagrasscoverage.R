test_that("Checking show_seagrasscoverage class", {
  result <- show_seagrasscoverage(seagrass)
  expect_is(result, 'NULL')
})

test_that("Checking show_seagrasscoverage maxyr error", {
  expect_error(show_seagrasscoverage(seagrass, maxyr = 2015))
})

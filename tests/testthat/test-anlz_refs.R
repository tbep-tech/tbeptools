test_that("Checking anlz_refs", {

  path <- 'https://raw.githubusercontent.com/tbep-tech/tbep-refs/master/tbep-refs.csv'
  result <- anlz_refs(path) %>%
    .[(length(.) - 3):length(.)]

  expect_equal(result, c("\tpages={},", "\tmisc={},", "\turl={},", "}\n"))
})

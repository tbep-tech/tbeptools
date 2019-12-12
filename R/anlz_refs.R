library(tidyverse)

refs <- read.csv('https://raw.githubusercontent.com/tbep-tech/tbep-refs/master/tbep-refs.csv', stringsAsFactors = F)

flds <- list(
  article = c('author', 'year', 'title', 'journal', 'volume', 'number', 'pages', 'doi', 'misc', 'url'),
  techreport = c('author', 'year', 'title', 'number', 'publisher', 'address', 'pages', 'misc', 'url'),
  incollection = c('author', 'year', 'title', 'number', 'booktitle', 'editor', 'publisher', 'address', 'pages', 'misc', 'url'),
  proceedings = c('author', 'year', 'title', 'number', 'publisher', 'address', 'misc', 'url')
)

articles <- refs %>%
  dplyr::group_by(type) %>%
  tidyr::nest() %>%
  dplyr::mutate(
    data = purrr::pmap(list(type, data), function(type, data){
      browser()
      fldsel <- flds[[type]]

      out <- data %>%
        select_at(c('index', fldsel)) %>%
        mutate_at(fldsel, ~paste0('={', ., '},')) %>%
        gather('var', 'val', -index) %>%
        unite('val', var, val, sep = '')

    })
  )


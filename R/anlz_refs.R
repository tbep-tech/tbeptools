#' Convert references csv to bib
#'
#' Convert references csv to bib
#'
#' @param path chr string of path to reference csv file
#'
#' @return A data frame with references formatted as bib entries
#'
#' @export
#'
#' @family analyze
#'
#' @examples
#'
#' # input and format
#' path <- 'https://raw.githubusercontent.com/tbep-tech/tbep-refs/master/tbep-refs.csv'
#' bibs <- anlz_refs(path)
#'
#' \dontrun{
#' # save output
#'  writeLines(bibs, 'formatted.bib')
#' }
anlz_refs <- function(path) {

  # import
  refs <- read.csv(path, stringsAsFactors = F)

  # specific fields for bib entry types
  flds <- list(
    article = c('author', 'year', 'title', 'journal', 'volume', 'number', 'pages', 'doi', 'misc', 'url'),
    techreport = c('author', 'year', 'title', 'number', 'publisher', 'address', 'pages', 'misc', 'url'),
    incollection = c('author', 'year', 'title', 'number', 'booktitle', 'editor', 'publisher', 'address', 'pages', 'misc', 'url'),
    proceedings = c('author', 'year', 'title', 'number', 'publisher', 'address', 'misc', 'url')
  )

  # format refernce csv as bib
  out <- refs %>%
    dplyr::group_by(type) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      data = purrr::pmap(list(type, data), function(type, data){

        fldsel <- flds[[type]]

        levs <- c('tag', fldsel, 'brk')

        tmp <- data %>%
          dplyr::mutate(
            tag = paste0('@', type, '{', tag, ','),
            brk = '}\n'
          ) %>%
          dplyr::select_at(c('index', 'tag', fldsel, 'brk')) %>%
          dplyr::mutate_at(fldsel, ~paste0('={', ., '},')) %>%
          dplyr::mutate(
            title = gsub('\\{', '{{', title),
            title = gsub('\\}', '}}', title)
          ) %>%
          tidyr::gather('var', 'val', -index) %>%
          dplyr::mutate(
            val = gsub('^\\=\\{NA\\},$', '={},', val),
            val = dplyr::case_when(
              !var %in% c('tag', 'brk') ~ paste0('\t', var, val),
              T ~ val
            ),
            var = factor(var, levels = levs)
          ) %>%
          dplyr::arrange(index, var) %>%
          dplyr::mutate_if(is.factor, as.character) %>%
          dplyr::group_by(index) %>%
          dplyr::mutate(subindex = letters[1:n()]) %>%
          dplyr::ungroup()

        return(tmp)

      })
    ) %>%
    tidyr::unnest(data) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(index, subindex) %>%
    mutate(val= gsub('\\#', '', val)) %>%
    dplyr::pull(val)

  return(out)

}


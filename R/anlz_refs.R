#' Convert references csv to bib
#'
#' Convert references csv to bib
#'
#' @param path chr string of path to reference csv file or data frame object
#'
#' @return A data frame with references formatted as bib entries
#'
#' @export
#'
#' @importFrom dplyr "%>%"
#'
#' @concept analyze
#'
#' @examples
#' \dontrun{
#' # input and format
#' path <- 'https://raw.githubusercontent.com/tbep-tech/tbep-refs/master/tbep-refs.csv'
#' bibs <- anlz_refs(path)
#'
#' # save output
#'  writeLines(bibs, 'formatted.bib')
#' }
anlz_refs <- function(path) {

  # import
  refs <- path
  if(!is.data.frame(refs))
    refs <- read.csv(refs, stringsAsFactors = F)

  # add index
  refs <- dplyr::mutate_all(refs, as.character) %>%
    dplyr::mutate(
      index = nrow(.):1
    ) %>%
    dplyr::select(index, everything())

  # # fixed authors not to edit, values correspond to index
  # authfix <- c('267', '262', '253', '249', '243', '239', '227', '222', '211', '207',
  #              '203', '194', '181', '180', '179', '178', '174', '173', '172',
  #              '163', '157', '156', '155', '149', '141', '136', '131', '129',
  #              '125', '123', '122', '120', '114', '107', '93', '84', '73', '61',
  #              '60', '52', '44', '43', '40', '34', '23', '20')

  # specific fields for bib entry types
  flds <- list(
    article = c('author', 'year', 'title', 'journal', 'volume', 'number', 'pages', 'doi', 'misc', 'url'),
    techreport = c('author', 'year', 'title', 'number', 'publisher', 'address', 'pages', 'misc', 'url', 'type'),
    incollection = c('author', 'year', 'title', 'number', 'booktitle', 'editor', 'publisher', 'address', 'pages', 'misc', 'url'),
    proceedings = c('author', 'year', 'title', 'number', 'publisher', 'address', 'misc', 'url')
  )

  # format reference csv as bib
  out <- refs %>%
    dplyr::group_by(type) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      data = purrr::pmap(list(type, data), function(type, data){

        typeent <- type

        fldsel <- flds[[type]]

        levs <- c('tag', fldsel, 'brk')

        # add type field for techreport to define how report number is shown
        if(typeent == 'techreport')
          data <- data |>
            mutate(
              type = case_when(
                grepl('^tbep', tag) ~ 'Technical report',
                grepl('^edu', tag) ~ 'Education product'
              )
            )

        tmp <- data %>%
          dplyr::mutate(
            tag = paste0('@', typeent, '{', tag, ','),
            brk = '}\n',
            author = paste0('{', author, '}')
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
    dplyr::arrange(-index, subindex) %>%
    mutate(val= gsub('\\#', '', val)) %>%
    dplyr::pull(val)

  return(out)

}


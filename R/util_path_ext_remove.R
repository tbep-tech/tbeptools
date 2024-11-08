#' Remove file extension from path TODO not exported yet b/c internal fs commands also need replacing
#'
#' Copied exactly from `fs::path_ext_remove()` to avoid dependency on `fs`.
#'
#' @param path
#'
#' @return A character vector of paths with the extension removed
#'
#' @examples
#' util_path_ext_remove("foo/bar.txt")
util_path_ext_remove <- function(path) {
  dir <- fs::path_dir(path)
  file <- sub("(?<!^|[.]|/)[.][^.]+$", "", fs::path_file(path),
              perl = TRUE)
  na <- is.na(path)
  no_dir <- dir == "." | dir == ""
  path[!na & no_dir] <- path_tidy(file[!na & no_dir])
  path[!na & !no_dir] <- path(dir[!na & !no_dir], file[!na &
                                                         !no_dir])
  path
}

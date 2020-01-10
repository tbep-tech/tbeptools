.onLoad <- function(libname, pkgname) {
  # if (Sys.info()[1] == "Linux") {
  #   dir.create('~/.fonts')
  #   file.copy("inst/extdata/fonts/Lato-Light.ttf", "~/.fonts")
  #   system('fc-cache -f ~/.fonts')
  # }
  if (Sys.info()[1] == "Windows") {
    windowsFonts()
    suppressMessages(extrafont::font_import(path = "inst/extdata/fonts/", pattern = "Lato-Light", prompt = FALSE))
    extrafont::loadfonts(device = "win", quiet = TRUE)
    extrafont::loadfonts(device = 'pdf', quiet = TRUE)
    windowsFonts()
  }
  # print(extrafont::fonts())
}

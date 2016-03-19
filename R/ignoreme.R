# this function is never called, but is here just to provide dummy usage of
# the miniUI. It's used for the RStudio addin, but because its usage is not
# inside the R folder, CRAN complains about it being imported.
nevercalled <- function(filename) {
  ignored <- miniUI::miniButtonBlock()
}

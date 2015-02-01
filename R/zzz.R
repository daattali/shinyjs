.onLoad <- function(libname, pkgname) {
  assign("shinyjsGlobals", new.env(), envir = parent.env(environment()))
}

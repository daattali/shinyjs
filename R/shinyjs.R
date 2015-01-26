#TODO use jquery show/hide
# implement jqueyr toggle, slidetoggle, slideup, slidedown, fadein, fadeout
# enable/disabel should be $("input").prop('disabled', true); / false
# use jquery addclass/removeclass

#TODO implement useShinyjs

# need to use   shinyjs::setSession(session) in server and shinyjs::useShinyjs() in ui


# or should i use options() like devtools does?
pkgEnv <- new.env()
pkgEnv$session <- NULL

shinyjs <- function(x, session) {
  pkgName <- "shinyjs"
  regex <- sprintf("^(%s:{2,3})((\\w)+)$", pkgName)
  fxn <- as.character(as.list(match.call()[1]))
  fxn <- sub(regex, "\\2", fxn)
  cat(fxn)
  cat("\n")
  if (missing(session)) {
    if (is.null(pkgEnv$session)) {
      stop("no session is set")
    }
    session <- pkgEnv$session
  }
  session$sendCustomMessage(type = fxn,
                            message = list(id = x))
}

closeSession <- function() {
  cat("closing session\n")
  pkgEnv$session <- NULL
}

#' @export
setSession <- function(session) {
  session$onSessionEnded(closeSession)
  pkgEnv$session <- session
}

#' @export
show <- shinyjs
#' @export
hide <- shinyjs
#' @export
enable <- shinyjs
#' @export
disable <- shinyjs






useShinyjs <- function() {
  cat(getwd())
  #includeScript(file.path('www', 'shinyjs-message-handler.js'))
  tags$script(HTML(sprintf(
    "Shiny.addCustomMessageHandler('%s', function(message) {
    %s(message.id)
}
  );
    Shiny.addCustomMessageHandler('%s', function(message) {
    %s(message.id)
    }
    );",
    "show","show", "hide", "hide"),

    "
    function hasClass(id, cls) {
    var e = document.getElementById(id);
    return (' ' + e.className + ' ').indexOf(' ' + cls + ' ') > -1;
    }

    function addClass(id, cls) {
    var e = document.getElementById(id);
    cls = ' ' + cls;
    e.className = e.className.replace(cls,'');
    e.className = e.className + cls;
    }

    function removeClass(id, cls) {
    var e = document.getElementById(id);
    cls = ' ' + cls;
    e.className = e.className.replace(cls,'');
    }

    function toggleClass(id, cls) {
    if (hasClass(id, cls)) {
    removeClass(id, cls);
    } else {
    addClass(id, cls);
    }
    }
    function show(id) {
    removeClass(id, 'hideme');
    }

    function hide(id) {
    addClass(id, 'hideme');
    }"
  ))
}

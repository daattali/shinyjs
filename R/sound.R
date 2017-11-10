#' Play a sound
#' 
#' Play a sound in the browser, using either a (relative or absolute) source URL
#' or a file on disk. Audio format support is browser-dependent (at the time of 
#' this writing, MP3 and AAC in MP4 are well supported, but see 
#' \href{https://developer.mozilla.org/en-US/docs/Web/HTML/Supported_media_formats#Browser_compatibility}{MDN}
#' for current information). Mobile browsers are not supported, as they 
#' generally do not allow audio to be automatically played without a user 
#' gesture.
#' 
#' @param src A relative or absolute URL. Mutually exclusive with \code{file}.
#' @param mime The mime type of the audio data, or \code{NULL} to guess based on
#'   file extension.
#' @param file A path to a file on disk. Mutually exclusive with \code{src}.
#' @param immediate Set to \code{FALSE} to delay sending the sound command to 
#'   the browser until all Shiny outputs have finished calculating and all
#'   observers have been run.
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),
#'       actionButton("play", "Play sound")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$play, {
#'         playSound(file = system.file("mp3/chime.mp3", package="shinyjs"))
#'       })
#'     }
#'   )
#' }
#'   
#' @importFrom base64enc dataURI
#' @export
playSound <- function(src, mime = NULL, file, immediate = TRUE) {
  if (missing(src) && missing(file)) {
    stop("Either src or file argument must be provided")
  }
  
  if (!missing(src) && !missing(file)) {
    stop("Either src or file argument must be provided, not both")
  }
  
  if (missing(src)) {
    if (is.null(mime)) {
      mime <- detectAudioMimeType(file)
    }
    src <- base64enc::dataURI(file = file, mime = mime)
  } else {
    if (is.null(mime)) {
      mime <- detectAudioMimeType(src)
    }
  }
  
  insertUI("body", "beforeEnd",
    tags$audio(src = src, type = mime, autoplay = NA),
    immediate = immediate
  )
}

#' @importFrom tools file_ext
detectAudioMimeType <- function(file) {
  switch(tools::file_ext(file),
    aac = "audio/aac",
    
    mp4 = "audio/mp4",
    m4a = "audio/mp4",
    
    mp1 = "audio/mpeg",
    mp2 = "audio/mpeg",
    mp3 = "audio/mpeg",
    mpg = "audio/mpeg",
    mpeg = "audio/mpeg",
    
    oga = "audio/ogg",
    ogg = "audio/ogg",
    
    wav = "audio/wav",
    webm = "audio/webm"
  )
}

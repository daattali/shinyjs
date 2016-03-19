# TODO remove colour

library(shiny)
library(miniUI)
library(magrittr)

css2 <- "
body { background: #fcfcfc; }
#author {
font-size: 0.8em;
}
#anycolarea {
text-align: center;
}
#anycolarea .shiny-input-container {
text-align: left;
margin: 0 auto;
}
.rcol {
width: 25px;
height: 25px;
border: 1px solid #DDD;
cursor: pointer;
display: inline-block;
}
.rcolbox {
margin-right: 10px;
margin-top: 10px;
display: inline-block;
vertical-align: top;
}
.rcolbig {
height: 80px;
display: block;
}
.rcolbox, .rcolbig, .rcolname {
width: 80px;
}
.rcol:hover {
box-shadow: 0 0 0 1px #fafafa, 0 0 0 3px #aaa;
}
.rcolbig:last-child {
margin-right: 0;
}
.rcolname {
word-break: break-all;
font-size: 0.9em;
font-style: italic;
}
#allcols {
margin-top: 5px;
}
#rclosecols, #allcols {
padding-bottom: 10px;
}
#customSliderContainer .irs-grid-text,
#customSliderContainer .irs-grid-pol  {
display: none;
}
#customSliderContainer .irs-single,
#customSliderContainer .irs-bar,
#customSliderContainer .irs-bar-edge {
  background: #666;
  border-color: #333;
}
"

col2hex <- function(col) {
  do.call(rgb, as.list(col2rgb(col) / 255))
}

NUM_CLOSE_COLS <- 10

closest_colour_hex <- function(target, n = NUM_CLOSE_COLS, superset = colours(distinct = TRUE)) {
  target <- as.numeric(col2rgb(target))

  superset %>%
    col2rgb %>%
    subtract(target) %>%
    apply(2, function(x) x %>% abs %>% sum) %>%
    order %>%
    .[1:n] %>%
    superset[.]
}

# Determine if a colour is dark or light
isColDark <- function(colhex) {
  getLuminance(colhex) <= 0.22
}

# Calculate the luminance of a colour
getLuminance <- function(colhex) {
  colrgb <- col2rgb(colhex)
  lum <- lapply(colrgb, function(x) {
    x <- x / 255;
    if (x <= 0.03928) {
      x <- x / 12.92
    } else {
      x <- ((x + 0.055) / 1.055)^2.4
    }
  })
  lum <- lum[[1]]*0.2126 + lum[[2]]*0.7152 + lum[[3]]*0.0722;
  lum
}

colourPickerGadget <- function(initNum = 1) {

  ui <- miniPage(
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = '
shinyjs.init = function() {
  $("#aaa").on("click", ".col", function(event) {
    var colnum = $(event.target).data("colnum");
    Shiny.onInputChange("jsColNum", colnum);
  });

  $("#rclosecols, #allcols").on("click", ".rcol", function(event) {
    var col = $(event.target).data("col");
    Shiny.onInputChange("jsCol", [col, Math.random()]);
  });

  $(document).on("shiny:recalculated", function(event) {
    if (event.target == $("#allcols")[0]) {
      $("#allcols-spinner").hide();
    }
  });
};
shinyjs.scrollToNum = function(num) {
  num = num - 1;
  var oldLeft = $("#gg").scrollLeft();
  var newLeft = $($(".col")[num]).position().left - $("#gg").width() + $($(".col")[num]).width();

  if (oldLeft < newLeft) {
    $("#gg").scrollLeft(newLeft); 
  }
};
shinyjs.scrollLeft = function() {
$("#gg").scrollLeft(10000);
};
                          '),
    shinyjs::inlineCSS(css2),
    shinyjs::inlineCSS("
#aaa {
position: relative;
-webkit-user-select: none;
-moz-user-select: none;
-khtml-user-select: none;
-ms-user-select: none;
}
#addColBtn, #removeColBtn, #aaa div.col {
  cursor:pointer;vertical-align: middle; border: 1px solid #eee;
font-weight:bold;display:inline-block;width:35px;height:35px;line-height:35px;text-align: center;
}
 #removeColBtn {margin-right: 10px;}
#removeColBtn[disabled] {
color: #bbb !important;
    background: #eee !important;
cursor: not-allowed;
}
#addColBtn, #removeColBtn {
font-size: 22px;
color: #333; background: #FAFAFA;
}
                       #addColBtn:hover,#removeColBtn:hover {background:#EEE}
#addColBtn:active,#removeColBtn:active{background: #DDD;}
                       #gg .form-group, #gg .checkbox {margin-bottom: 0;}
                       #aaa div.col {font-size:15px;margin-right:2px;color:black;}
#aaa div.col.col-dark {color: #ddd;}
#aaa div.col:hover {box-shadow:0 0 0 1px #fafafa, 0 0 0 3px #BBB;}    
#aaa div.col.selected {cursor:default;box-shadow:0 0 0 1px #fafafa, 0 0 0 3px black; }

"),
    gadgetTitleBar(span(strong("Colour Picker"),
                        span(id = "author", "By", a(href = "http://deanattali.com", "Dean Attali")))),
    shinyjs::hidden(div(
      id = "done-overlay",
style="
    position: absolute;
    right: 0;
    bottom: 0;
    left: 0;
    background: #FCFCFC;
    top: 45px;
    z-index: 100;
    color: black;
    text-align: center;
    font-size: 30px;
    padding-top: 130px;
    ", "Converting colours to R names...", icon("spinner", class = "fa-spin"))),
    div(
      id="gg",
      style="background: #fff; border-bottom: 1px solid #eee;padding:10px 10px 20px;overflow-x:overlay;",
      div(
        style="margin-bottom:5px;",
        span("Selected colours", style="
             font-weight: bold;
             font-size: 16px;
             ")),
      div(id="aaa",style="white-space:nowrap;",
          div(id="addColBtn", icon("plus"),title="Add another colour"),
          div(id="removeColBtn", icon("trash-o"),title="Remove selected colour"),
          uiOutput("selectedCols", inline = TRUE)
      ),
      checkboxInput("returnTypeName", "Return colour name (eg. \"white\") instead of HEX value (eg. #FFFFFF) when possible", width = "100%")
    ),
    miniTabstripPanel(
      id = "colourType",


      miniTabPanel(
        value = "anycolour",
        "Any colour",
        icon = icon("globe"),
        miniContentPanel(
          div(
            id = "anycolarea",
            br(),
            shinyjs::colourInput("anyColInput", "Select any colour",
                                 showColour = "both", value = "white")
          )
        )
      ),
      miniTabPanel(
        value = "rcolour",
        "Find R colour",
        icon = icon("search"),
        miniContentPanel(
          fluidRow(
            column(
              6,
              shinyjs::colourInput("rclosecol", "Show R colours similar to this colour",
                                   showColour = "both", value = "orange")
            ),
            column(
              6,
              div(id = "customSliderContainer",
                sliderInput("numSimilar", "How many colours to show", 1, 40, 8, step = 1)
              )
            )
          ),
          br(),
          strong("Click a colour to select it"),
          uiOutput("rclosecols")
        )
      ),
      miniTabPanel(
        value = "rcolour",
        "All R colours",
        icon = icon("paint-brush"),
        miniContentPanel(
          strong("Click a colour to select it"),
          br(),
          div(id = "allcols-spinner", style="    font-size: 60px;
    text-align: center;
              margin-top: 40px;", icon("spinner", "fa-spin")),
          uiOutput("allcols")
        )
      )
    )
  )

  server <- function(input, output, session) {

    values <- reactiveValues(
      selectedCols = NULL,
      selectedNum = NULL
    )
    
    # Initial values
    if (!is.numeric(initNum) || initNum < 1 || length(initNum) > 1) {
      warning("Invalid number of colours; defaulting to 1")
      initNum <- 1
    }
    values$selectedCols <- rep("#FFFFFF", initNum)
    values$selectedNum <- 1

    # User canceled
    observeEvent(input$cancel, {
      stopApp(stop("User canceled colour selection", call. = FALSE))
    })

    # Don't allow user to remove the last colour
    observe({
      shinyjs::toggleState("removeColBtn", condition = length(values$selectedCols) > 1)
    })
        
    # User is done selecting colours
    observeEvent(input$done, {
      cols <- values$selectedCols
      
      if (input$returnTypeName) {
        shinyjs::hide(selector = "#gg, .gadget-tabs-container, .gadget-tabs-content-container")
        shinyjs::show("done-overlay")
        shinyjs::disable(selector = "#cancel, #done")
        cols <- lapply(cols, function(col) {
          closest <- closest_colour_hex(col, n = 1)
          if (col == col2hex(closest)) {
            col <- closest
          }
          col
        })
        cols <- unname(unlist(cols))
      }
      
      stopApp(cols)
    })
    
    # Add another colour to select
    shinyjs::onclick("addColBtn", {
      values$selectedCols <- c(values$selectedCols, "#FFFFFF")
    })
    
    # Remove the selected colour
    shinyjs::onclick("removeColBtn", {
      if (length(values$selectedCols) == 1) {
        return()
      }
      
      values$selectedCols <- values$selectedCols[-values$selectedNum]
      if (values$selectedNum > length(values$selectedCols)) {
        values$selectedNum <- length(values$selectedCols)
      }
    })    
    
    # Render the chosen colours
    output$selectedCols <- renderUI({
      lapply(seq_along(values$selectedCols), function(colNum) {
        if (colNum == values$selectedNum) {
          cls <- "col selected"
        } else {
          cls <- "col"
        }
        if (isColDark(values$selectedCols[colNum])) {
          cls <- paste0(cls, " col-dark")
        }
        div(
          style = paste0("background:", values$selectedCols[colNum]),
          `data-colnum` = colNum,
          class = cls,
          colNum
        )
      })
    })
    
    # Receive event from JS: a different colour number was selected
    observeEvent(input$jsColNum, {
      values$selectedNum <- input$jsColNum
    })
    
    # A colour from the "any colour" input is chosen
    observeEvent(input$anyColInput, {
      values$selectedCols[values$selectedNum] <- input$anyColInput
    })
    
    # Receive event from JS: an R colour was selected
    # Because of how Shiny works, the input from JS needs to also contain
    # a dummy random variable, so that when the user chooses the same colour
    # twice, it will register the second time as well
    observeEvent(input$jsCol, {
      values$selectedCols[values$selectedNum] <- input$jsCol[1]
    })    
    
    # Render all the R colours
    output$allcols <- renderUI({
      lapply(
        colours(distinct = TRUE),
        function(x) {
          actionLink(
            paste0("rcol-", x),
            label = NULL,
            class = "rcol",
            style = paste0("background: ", col2hex(x)),
            title = x,
            `data-col` = col2hex(x)
          )
        }
      )
    })

    # After the user chooses a colour, show all the similar R colours 
    output$rclosecols <- renderUI({
      rcols <- closest_colour_hex(input$rclosecol, n = input$numSimilar)

      tagList(
        div(
          id = "rcolsnames",
          lapply(
            seq_along(rcols),
            function(x) {
              div(
                class = "rcolbox",
                actionLink(
                  paste0("rclosecol-", x),
                  label = NULL,
                  class = "rcol rcolbig",
                  style = paste0("background: ", col2hex(rcols[x])),
                  title = rcols[x],
                  `data-col` = col2hex(rcols[x])
                ),
                span(rcols[x], class = "rcolname")
              )
            }
          )
        )
      )
    })
  }

  viewer <- dialogViewer("Colour Picker", width = 800, height = 700)
  runGadget(ui, server, viewer = viewer, stopOnCancel = FALSE)
}

colourPicker <- function() {
  colourPickerGadget()
}

colourPickerAddin <- function() {
  col <- colourPickerGadget()
  rstudioapi::insertText(text = paste0('"', col, '"'))
}

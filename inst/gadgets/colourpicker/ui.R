library(shiny)
library(miniUI)

jsfuncs <- '
shinyjs.init = function() {
  $("#selected-cols-row").on("click", ".col", function(event) {
    var colnum = $(event.target).data("colnum");
    Shiny.onInputChange("jsColNum", colnum);
  });

  $("#rclosecolsSection, #allColsSection").on("click", ".rcol", function(event) {
    var col = $(event.target).data("col");
    Shiny.onInputChange("jsCol", [col, Math.random()]);
  });

  $(document).on("shiny:recalculated", function(event) {
    if (event.target == $("#allColsSection")[0]) {
      $("#allcols-spinner").hide();
    }
  });

  $(document).keypress(function(event) {
    if (event.which == 13) {
      $("#done").click();
    }
  });
};
'

miniPage(
  shinyjs::useShinyjs(),
  shinyjs::extendShinyjs(functions = c(), text = jsfuncs),
  tags$head(includeCSS(file.path("www", "app.css"))),

  gadgetTitleBar(
    span(strong("Colour Picker"),
         span(id = "author", "By",
              a(href = "http://deanattali.com", "Dean Attali")))
  ),

  # Retrieving R names for for selected colours when user is done can take a
  # second, so this overlay shows a "please wait" message
  shinyjs::hidden(
    div(id = "done-overlay",
        "Converting colours to R names...",
        icon("spinner", class = "fa-spin")
    )
  ),

  # Header section - shows the selected colours
  div(
    id = "header-section",
    div(
      id = "header-title",
      "Selected colours"
    ),
    div(
      id = "selected-cols-row",style="",
      div(id = "addColBtn",
          icon("plus"),
          title = "Add another colour"
      ),
      div(id = "removeColBtn",
          icon("trash-o"),
          title = "Remove selected colour"
      ),
      uiOutput("selectedCols", inline = TRUE)
    ),
    checkboxInput(
      "returnTypeName",
      "Return colour name (eg. \"white\") instead of HEX value (eg. #FFFFFF) when possible",
      width = "100%"
    )
  ),

  miniTabstripPanel(

    # Tab 1 - choose any colour
    miniTabPanel(
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

    # Tab 2 - choose an R colour similar to a colour you choose
    miniTabPanel(
      "Find R colour",
      icon = icon("search"),
      miniContentPanel(
        fluidRow(
          column(
            6,
            shinyjs::colourInput("rclosecolInput", "Show R colours similar to this colour",
                                 showColour = "both", value = "orange")
          ),
          column(
            6,
            div(id = "customSliderContainer",
                sliderInput("numSimilar", "How many colours to show",
                            min = 1, max = 40, value = 8, step = 1)
            )
          )
        ),
        br(),
        strong("Click a colour to select it"),
        uiOutput("rclosecolsSection")
      )
    ),

    # Tab 3 - choose any R colour
    miniTabPanel(
      "All R colours",
      icon = icon("paint-brush"),
      miniContentPanel(
        strong("Click a colour to select it"),
        br(),
        div(id = "allcols-spinner", icon("spinner", "fa-spin")),
        uiOutput("allColsSection")
      )
    )
  )
)

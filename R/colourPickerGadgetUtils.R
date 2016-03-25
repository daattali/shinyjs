# Get the HEX of a colour
col2hex <- function(col) {
  do.call(rgb, as.list(col2rgb(col) / 255))
}

# Get the most similar R colours to a given colour
closestColHex <- function(target, n = 3, superset = colours(distinct = TRUE)) {
  target <- as.numeric(col2rgb(target))
  dist_mat <- col2rgb(superset) - target
  dist <- apply(dist_mat, 2, function(x) sum(abs(x)))
  closest <- order(dist)[1:n]
  superset[closest]
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

createColsMap <- function() {
  allcols <- colours(distinct = TRUE)
  rgbVals <- as.vector(col2rgb(allcols)) / 255
  reds <- rgbVals[seq(from = 1, to = length(rgbVals), by = 3)]
  greens <- rgbVals[seq(from = 2, to = length(rgbVals), by = 3)]
  blues <- rgbVals[seq(from = 3, to = length(rgbVals), by = 3)]
  hex <- rgb(reds, greens, blues)
  colsMap <- allcols
  names(colsMap) <- hex
  colsMap
}

getColNameOrHex <- function(hex) {
  if (is.null(.globals$colsMap)) {
    .globals$colsMap <- createColsMap()
  }

  if (hex %in% names(.globals$colsMap)) {
    unname(.globals$colsMap[hex])
  } else {
    hex
  }
}

getCpGadgetShinyjsText <- function() {
'
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
}

getCpGadgetCSS <- function() {
'
/* General */
body {
  background: #fcfcfc;
}
#author {
  font-size: 0.8em;
}

#header-section {
  background: #fff;
  border-bottom: 1px solid #eee;
  padding: 10px 10px 20px;
  overflow-x: overlay;
}
#header-title {
  margin-bottom: 5px;
  font-weight: bold;
  font-size: 16px;
}
#header-section .form-group,
#header-section .checkbox {
  margin-bottom: 0;
}

#selected-cols-row {
  position: relative;
  white-space: nowrap;
  -webkit-user-select: none;
  -moz-user-select: none;
  -khtml-user-select: none;
  -ms-user-select: none;
}

#addColBtn,
#removeColBtn,
#selected-cols-row .col {
  cursor: pointer;
  vertical-align: middle;
  border: 1px solid #eee;
  font-weight: bold;
  display: inline-block;
  width: 35px;
  height: 35px;
  line-height: 35px;
  text-align: center;
}
#removeColBtn {
  margin-right: 10px;
}
#removeColBtn.disabled {
  color: #bbb !important;
  background: #eee !important;
  cursor: not-allowed;
}
#addColBtn,
#removeColBtn {
  font-size: 22px;
  color: #333;
  background: #FAFAFA;
}
#addColBtn:hover,
#removeColBtn:hover {
  background: #EEE
}
#addColBtn:active,
#removeColBtn:active {
  background: #DDD;
}

#selected-cols-row .col {
  font-size: 15px;
  margin-right: 2px;
  color: black;
}
#selected-cols-row .col.col-dark {
  color: #ddd;
}
#selected-cols-row .col:hover {
  box-shadow: 0 0 0 1px #fafafa, 0 0 0 3px #BBB;
}
#selected-cols-row .col.selected {
  cursor: default;
  box-shadow: 0 0 0 1px #fafafa, 0 0 0 3px #999;
}

/* Tab 1 - any colour */

#anycolarea {
  text-align: center;
}
#anycolarea .shiny-input-container {
  text-align: left;
  margin: 0 auto;
}

/* R colours in tab 2 & 3 */

.rcol {
  width: 25px;
  height: 25px;
  border: 1px solid #DDD;
  cursor: pointer;
  display: inline-block;
}
.rcol:hover {
  box-shadow: 0 0 0 1px #fafafa, 0 0 0 3px #aaa;
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
.rcolbig:last-child {
  margin-right: 0;
}
.rcolbox,
.rcolbig,
.rcolname {
  width: 80px;
}
.rcolname {
  word-break: break-all;
  font-size: 0.9em;
  font-style: italic;
}
#rclosecolsSection,
#allColsSection {
  padding-bottom: 10px;
}

/* Tab 2 - similar R colours */

#customSliderContainer .irs-grid-text,
#customSliderContainer .irs-grid-pol {
  display: none;
}
#customSliderContainer .irs-single,
#customSliderContainer .irs-bar,
#customSliderContainer .irs-bar-edge {
  background: #666;
  border-color: #333;
}

/* Tab 3 - all R colours */

#allColsSection {
  margin-top: 5px;
}
#allcols-spinner {
  font-size: 60px;
  text-align: center;
  margin-top: 40px;
}
'
}

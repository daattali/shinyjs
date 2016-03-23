# Get the HEX of a colour
col2hex <- function(col) {
  do.call(rgb, as.list(col2rgb(col) / 255))
}

# Get the most similar R colours to a given colour
closest_colour_hex <- function(target, n = 3, superset = colours(distinct = TRUE)) {
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

allcols <- colours(distinct = TRUE)
rgbVals <- as.vector(col2rgb(allcols)) / 255
reds <- rgbVals[seq(from = 1, to = length(rgbVals), by = 3)]
greens <- rgbVals[seq(from = 2, to = length(rgbVals), by = 3)]
blues <- rgbVals[seq(from = 3, to = length(rgbVals), by = 3)]
hex <- rgb(reds, greens, blues)
colsMap <- allcols
names(colsMap) <- hex

get_name_or_hex <- function(hex) {
  if (hex %in% names(colsMap)) {
    unname(colsMap[hex])
  } else {
    hex
  }
}

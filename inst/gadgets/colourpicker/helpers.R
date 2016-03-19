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

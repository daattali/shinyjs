# some sample R expressions to try
examples <- c(
  'toggle("test")',
  'toggle("test", TRUE, "fade", 2)',
  'toggle(id = "test", anim = TRUE, time = 2, animType = "slide")',
  'hide("test")',
  'show("test")',
  'alert(R.Version())',
  'onclick("btn", alert(date()))',
  'disable("btn")',
  'enable("btn")',
  'innerHTML("btn", "What a nice button")',
  'innerHTML("test", paste("The time is", date()))',
  'addClass("test", "green")',
  'removeClass("test", "green")',
  'toggleClass("test", "green")'
)
names(examples) <- seq_along(examples)

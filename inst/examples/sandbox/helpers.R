# some sample R expressions to try
examples <- c(
  'toggle("test")',
  'toggle("test", TRUE, "fade", 2)',
  'toggle(id = "test", anim = TRUE, time = 2, animType = "slide")',
  'hide("test")',
  'show("test")',
  'message(R.Version())',
  'onclick("btn", message(date()))',
  'toggleState("btn")',
  'disable("btn")',
  'enable("btn")',
  'text("btn", "What a nice button")',
  'text("test", paste("The time is", date()))',
  'addClass("test", "green")',
  'removeClass("test", "green")',
  'toggleClass("test", "green")'
)
names(examples) <- seq_along(examples)

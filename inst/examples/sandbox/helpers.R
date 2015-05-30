# some sample R expressions to try
examples <- c(
  'toggle("test")',
  'toggle(delay = 0.5, selector = "a")',
  'toggle("test", TRUE, "fade", 2)',
  'toggle(id = "test", anim = TRUE, time = 2, animType = "slide")',
  'hide("test")',
  'show("test")',
  'reset("expr")',
  'info(R.Version())',
  'onclick("btn", info(date()))',
  'toggleState("btn")',
  'disable("btn")',
  'enable("btn")',
  'toggle(id = "btn", condition = (sample(2, 1) == 1))',
  'text("btn", "What a nice button")',
  'text("test", paste("The time is", date()))',
  'addClass("test", "green")',
  'removeClass("test", "green")',
  'toggleClass("test", "green")'
)
names(examples) <- seq_along(examples)

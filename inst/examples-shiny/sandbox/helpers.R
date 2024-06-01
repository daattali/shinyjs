# some sample R expressions to try
examples <- c(
  'toggle("test")',
  'delay(500, toggle("test"))',
  'toggle(selector = "a")',
  'toggle("test", TRUE, "slide", 2)',
  'toggle(id = "test", anim = TRUE, time = 2, animType = "slide")',
  'hide("test")',
  'show("test")',
  'reset("runcode_expr")',
  'alert(R.Version())',
  'onclick("btn", alert(date()))',
  'toggleState("btn")',
  'disable("btn")',
  'enable("btn")',
  'toggle(id = "btn", condition = (sample(2, 1) == 1))',
  'html("btn", "What a nice button")',
  'html("test", paste("The time is", date()))',
  'addClass("test", "green")',
  'removeClass("test", "green")',
  'toggleClass("test", "green")'
)
names(examples) <- seq_along(examples)

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

shinyjs.colour = function(params) {
  var defaultParams = {
    id : null,
    col : "red"
  };
  params = shinyjs.getParams(params, defaultParams);

  var el = $("#" + params.id);
  el.css('color', params.col);
}

shinyjs.increment = function(params) {
  var defaultParams = {
    id : null,
    num : 1
  };
  params = shinyjs.getParams(params, defaultParams);

  var el = $("#" + params.id);
  el.text(parseInt(el.text()) + params.num);
}

shinyjs.noop = function(params) {};

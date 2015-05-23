shinyjs = function() {
  return {

    // Helper function to determine the parameters.
    // Given a set of user-provided parameters and some default parameters,
    // return a dictionary of key-value parameter pairs.
    // The user parameters can either be an (unnamed) array, in which case
    // we assume the order of the parameters, or it can be a dictionary with
    // key-value parameter pairs.
    getParams : function (params, defaultParams) {
      var finalParams = defaultParams;
      if (typeof params == "string") {
        params = Array(params);
      }
      if (params instanceof Array) {
        for (var i = 0; i < params.length; i++) {
          finalParams[Object.keys(finalParams)[i]] = params[i];
        }
      } else {
        $.extend(finalParams, params);
      }

      return finalParams;
    },

    // call this function once (automatically) to initialize some stuff
    initShinyjs : function() {
      shinyjs.initResettables();
    },

    // if there are any resettable input elements, keep track of their
    // initial value
    initResettables : function() {
      var getDate = function(el) {
        if (el[0].hasAttribute('data-initial-date') &&
            el.attr('data-initial-date') != "") {
          return el.attr('data-initial-date');
        }
        var today = new Date();
        var yyyy = today.getFullYear().toString();                                    var mm = (today.getMonth() + 1).toString();
        var dd  = today.getDate().toString();
        return yyyy + '-' + (mm[1]?mm:"0"+mm[0]) + '-' + (dd[1]?dd:"0"+dd[0]);
      };

      var SHINY_INPUT_CLASS = "shiny-input-container";
      var resettables = $(".shinyjs-resettable-init");
      for (var i = 0; i < resettables.length; i++) {
        var resettable = $(resettables[i]);
        var inputContainers = resettable.hasClass(SHINY_INPUT_CLASS) ? resettable : resettable.find("." + SHINY_INPUT_CLASS);

        for (var j = 0; j < inputContainers.length; j++) {
          var inputContainer = $(inputContainers[j]);
          var input = inputContainer;
          var foundInput = true;
          if (input.hasClass("shiny-date-input")) {
            input = input.children("input");
            input.attr("data-shinyjs-resettable-type", "Date");
            input.attr("data-shinyjs-resettable-value", getDate(input));
            input.attr("data-shinyjs-resettable-id", inputContainer.attr('id'));
          }
          else if (input.hasClass("shiny-date-range-input")) {
            input.attr("data-shinyjs-resettable-type", "DateRange");
            var value = getDate($(input.find("input")[0])) + "," +
                        getDate($(input.find("input")[1]));
            input.attr("data-shinyjs-resettable-value", value);
          }
          else if (input.hasClass("shiny-input-checkboxgroup")) {
            input.attr("data-shinyjs-resettable-type", "CheckboxGroup");
            var selected = new Array();
            var selectedEls = input.find("input[type='checkbox']:checked");
            selectedEls.each(function() {
              selected.push($(this).val());
            })
            input.attr("data-shinyjs-resettable-value", selected.join(","));
          }
          else if (input.hasClass("shiny-input-radiogroup")) {
            input.attr("data-shinyjs-resettable-type", "RadioButtons");
            var selected = input.find("input[type='radio']:checked").val();
            input.attr("data-shinyjs-resettable-value", selected);
          }
          else if (input.children(".js-range-slider").length > 0) {
            input = input.children(".js-range-slider");
            input.attr("data-shinyjs-resettable-type", "Slider");
            input.attr("data-shinyjs-resettable-value", input.attr('data-from'));
          }
          else if (input.find("select").length > 0) {
            input = input.find("select");
            input.attr("data-shinyjs-resettable-type", "Select");
            var value = input.val();
            if (value === null) {
              value = "";
            } else if (value instanceof Array) {
              value = value.join(",");
            }
            input.attr("data-shinyjs-resettable-value", value);
          }
          else if (input.children("input[type='number']").length > 0) {
            input = input.children("input[type='number']");
            input.attr("data-shinyjs-resettable-type", "Numeric");
          } else if (input.children("input[type='text']").length > 0) {
            input = input.children("input[type='text']");
            input.attr("data-shinyjs-resettable-type", "Text");
          } else if (input.find("input[type='checkbox']").length > 0) {
            input = input.find("input[type='checkbox']");
            input.attr("data-shinyjs-resettable-type", "Checkbox");
            input.attr("data-shinyjs-resettable-value", input.prop('checked'));
          } else {
            foundInput = false;
          }

          if (foundInput) {
            input.addClass("shinyjs-resettable");
            if (!input[0].hasAttribute('data-shinyjs-resettable-id')) {
              input.attr('data-shinyjs-resettable-id', input.attr('id'));
            }
            if (!input[0].hasAttribute('data-shinyjs-resettable-value')) {
              input.attr('data-shinyjs-resettable-value', input.val());
            }
          }
        }
      }
    },

    isHidden : function(el) {
      return el.css("display") === "none";
    },

    isDisabled : function(el) {
      return el.prop('disabled') === true;
    },

    // -----------------------------------------------------------------
    // ------ All functions below are exported shinyjs function --------
    // The documentation for function xyz is available in R via ?shinyjs::xyz

    show : function (params) {
      var defaultParams = {
        id : null,
        anim : false,
        animType : "slide",
        time : 0.5,
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);

      if (!params.anim) {
        el.show();
      } else {
        if (params.animType == "fade") {
          el.fadeIn(params.time * 1000);
        } else {
          el.slideDown(params.time * 1000);
        }
      }

      // If this was initially hidden when app started, tell shiny that it's
      // now visible so that it can properly render dynamic elements
      if (el.hasClass("shinyjs-hidden-init")) {
        el.trigger("shown");
        el.removeClass("shinyjs-hidden-init");
      }
    },

    hide : function (params) {
      var defaultParams = {
        id : null,
        anim : false,
        animType : "slide",
        time : 0.5,
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      if (!params.anim) {
        el.hide();
      } else {
        if (params.animType == "fade") {
          el.fadeOut(params.time * 1000);
        } else {
          el.slideUp(params.time * 1000);
        }
      }
    },

    toggle : function (params) {
      var defaultParams = {
        id : null,
        anim : false,
        animType : "slide",
        time : 0.5,
        condition : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);

      if (params.condition === null) {
        params.condition = shinyjs.isHidden(el);
      }
      if (params.condition) {
        shinyjs.show(params);
      } else {
        shinyjs.hide(params);
      }
    },

    addClass : function (params) {
      var defaultParams = {
        id : null,
        class : null
      };
      params = shinyjs.getParams(params, defaultParams);

      $("#" + params.id).addClass(params.class);
    },

    removeClass : function (params) {
      var defaultParams = {
        id : null,
        class : null
      };
      params = shinyjs.getParams(params, defaultParams);

      $("#" + params.id).removeClass(params.class);
    },

    toggleClass : function (params) {
      var defaultParams = {
        id : null,
        class : null,
        condition : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);

      if (params.condition === null) {
        params.condition = !el.hasClass(params.class);
      }

      if (params.condition) {
        shinyjs.addClass(params);
      } else {
        shinyjs.removeClass(params);
      }
    },

    enable : function (params) {
      var defaultParams = {
        id : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);

      // Special case for selectize inputs
      if (el.hasClass("selectized")) {
        el.selectize()[0].selectize.enable();
      }

      el.prop('disabled', false);
    },

    disable : function (params) {
      var defaultParams = {
        id : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);

      // Special case for selectize inputs
      if (el.hasClass("selectized")) {
        el.selectize()[0].selectize.disable();
      }

      el.prop('disabled', true);
    },

    toggleState : function (params) {
      var defaultParams = {
        id : null,
        condition : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      if (params.condition === null) {
        params.condition = shinyjs.isDisabled(el);
      }
      if (params.condition) {
        shinyjs.enable(params);
      } else {
        shinyjs.disable(params);
      }
    },

    text : function (params) {
      var defaultParams = {
        id : null,
        text : null,
        add : false
      };
      params = shinyjs.getParams(params, defaultParams);

      if (params.add) {
        $("#" + params.id)[0].innerHTML += params.text;
      } else {
        $("#" + params.id)[0].innerHTML = params.text;
      }

    },

    info : function (params) {
      var defaultParams = {
        text : null
      }
      params = shinyjs.getParams(params, defaultParams);

      alert(JSON.stringify(params.text, null, 4));
    },

    logjs : function (params) {
      var defaultParams = {
        text : null
      }
      params = shinyjs.getParams(params, defaultParams);

      console.log(params.text);
    },

    // onclick function is more complicated than the rest of the shinyjs functions
    // we attach a click handler to an element and when it's clicked we call Shiny
    onclick : function (params) {
      var defaultParams = {
        id : null,
        shinyInputId : null,
        add : false
      }
      params = shinyjs.getParams(params, defaultParams);

      var elId = "#" + params.id;
      var shinyInputId = params.shinyInputId;
      var attrName = "data-shinyjs-onclick";

      // if this is the first click handler we attach to this element, initialize
      // the data attribute and add the onclick event handler
      var first = !$(elId)[0].hasAttribute(attrName);
      if (first) {
        $(elId).attr(attrName, JSON.stringify(Object()));

        $(elId).click(function() {
          var oldValues = JSON.parse($(elId).attr(attrName));
          var newValues = Object();
          $.each(oldValues, function(key, value) {
            var newValue = value + 1;
            newValues[key] = newValue;
            Shiny.onInputChange(key, newValue);
          });
          $(elId).attr(attrName, JSON.stringify(newValues));
        });
      }

      // if we want this action to overwrite existing ones, unbind click handler
      if (params.add) {
        var attrValue = JSON.parse($(elId).attr(attrName));
      } else {
        var attrValue = Object();
      }
      attrValue[shinyInputId] = 0;
      $(elId).attr(attrName, JSON.stringify(attrValue));
    },

    reset : function(params) {
      var defaultParams = {
        id : null
      }
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      var resettables;
      if (el.hasClass("shinyjs-resettable")) {
        resettables = el;
      } else {
        resettables = el.find(".shinyjs-resettable");
      }

      var messages = Object();
      for (var i = 0; i < resettables.length; i++) {
        var resettable = $(resettables[i]);
        var type = resettable.attr('data-shinyjs-resettable-type');
        var value = resettable.attr('data-shinyjs-resettable-value');
        var id = resettable.attr('data-shinyjs-resettable-id');
        if (id !== undefined) {
          messages[id] = { 'type' : type, 'value' : value };
        }
      }
      Shiny.onInputChange("shinyjs-resettable-" + params.id, messages);
    }
  };
}();

// Initialize shinyjs on the JS side
$(function() { shinyjs.initShinyjs(); });

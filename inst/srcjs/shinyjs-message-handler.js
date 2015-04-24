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

    isHidden : function(el) {
      return el.css("display") === "none";
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
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      var hidden = shinyjs.isHidden(el);
      if (hidden) {
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
        class : null
      };
      params = shinyjs.getParams(params, defaultParams);

      $("#" + params.id).toggleClass(params.class);
    },

    enable : function (params) {
      var defaultParams = {
        id : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var element = $("#" + params.id);

      // Special case for selectize inputs
      if (element.hasClass("selectized")) {
        element.selectize()[0].selectize.enable();
      }

      element.prop('disabled', false);
    },

    disable : function (params) {
      var defaultParams = {
        id : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var element = $("#" + params.id);

      // Special case for selectize inputs
      if (element.hasClass("selectized")) {
        element.selectize()[0].selectize.disable();
      }

      element.prop('disabled', true);
    },

    toggleState : function (params) {
      var defaultParams = {
        id : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var element = $("#" + params.id);
      var disabled = (element.prop('disabled') === true);
      if (disabled) {
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
    }
  };
}();

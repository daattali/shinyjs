shinyjs = function() {
  return {

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

     show : function (params) {
      var defaultParams = {
        id : null,
        anim : false,
        animType : "slide",
        time : 500,
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      if (!params.anim) {
        el.show();
      } else {
        if (params.animType == "fade") {
          el.fadeIn(params.time);
        } else {
          el.slideDown(params.time);
        }
      }
    },

     hide : function (params) {
      var defaultParams = {
        id : null,
        anim : false,
        animType : "slide",
        time : 500,
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      if (!params.anim) {
        el.hide();
      } else {
        if (params.animType == "fade") {
          el.fadeOut(params.time);
        } else {
          el.slideUp(params.time);
        }
      }
    },

    toggle : function (params) {
      var defaultParams = {
        id : null,
        anim : false,
        animType : "slide",
        time : 500,
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      if (!params.anim) {
        el.toggle();
      } else {
        if (params.animType == "fade") {
          el.fadeToggle(params.time);
        } else {
          el.slideToggle(params.time);
        }
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

      $("#" + params.id).prop('disabled', false);
    },

    disable : function (params) {
      var defaultParams = {
        id : null
      };
      params = shinyjs.getParams(params, defaultParams);

      $("#" + params.id).prop('disabled', true);
    }
  };
}();

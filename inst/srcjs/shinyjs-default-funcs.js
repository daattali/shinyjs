// shinyjs 0.1.2 by Dean Attal
// Perform common JavaScript operations in Shiny apps using plain R code

shinyjs = function() {

  // helper function to get the initial date from a bootstrap date element
  // if there is no initial date, return the current date
  var getInputDate = function(el) {
    if (el[0].hasAttribute('data-initial-date') &&
        el.attr('data-initial-date') != "") {
      return el.attr('data-initial-date');
    }
    var today = new Date();
    var yyyy = today.getFullYear().toString();
    var mm = (today.getMonth() + 1).toString();
    var dd  = today.getDate().toString();
    return yyyy + '-' + (mm[1]?mm:"0"+mm[0]) + '-' + (dd[1]?dd:"0"+dd[0]);
  };

  // get an element by id using JQuery (escape chars that have special selector meaning)
  var jqid = function(id) {
    return $("#" + id.replace( /(:|\.|\[|\]|,)/g, "\\$1" ));
  };

  // disable all the elements that were initialized as disabled
  var initDisabled = function() {
    $.each(
      $(".shinyjs-disabled"),
      function(key, el) {
        var input = $(el).find("[id]");
        if (input.length > 0) {
          shinyjs.disable({ elements : input })
        }
      }
    );
  };

  // find all shiny input elements and set them up to allow them to be reset
  var initResettables = function() {
    // grab all the shiny input containers that exist when the app loads
    var inputContainers = $(".shiny-input-container");
    initResettable(inputContainers);

    // observer new elements added to the document so that dynamically generated
    // elements can also be resettable
    var canObserveMutation = 'MutationObserver' in window;
    if (canObserveMutation) {
      var mutationCallback = function(mutations) {
        mutations.forEach(function(mutation) {
          $.each(mutation.addedNodes, function(idx, node) {
            initResettable($(node).find(".shiny-input-container"));
            if ($(node).hasClass("shiny-input-container")) {
              initResettable($(node));
            }
          });
        });
      };
      var observer = new MutationObserver(mutationCallback);
      observer.observe(
        document.body,
        { childList : true,
          subtree : true
        }
      );
    }
  };

  // go through every Shiny input and based on what kind of input it is,
  // add some information to the HTML tag so that we can know how to
  // update it back to its original value
  var initResettable = function(els) {
     for (var j = 0; j < els.length; j++) {
        var inputContainer = $(els[j]);
        var input = inputContainer;
        var foundInput = true;
        var inputType = null,
            inputValue = null,
            inputId = null;

        // dateInput
        if (input.hasClass("shiny-date-input")) {
          input = input.children("input");
          inputType = "Date";
          inputValue = getInputDate(input);
          inputId = inputContainer.attr('id');
        }
        // dateRangeInput
        else if (input.hasClass("shiny-date-range-input")) {
          inputType = "DateRange";
          inputValue = getInputDate($(input.find("input")[0])) + "," +
                       getInputDate($(input.find("input")[1]));
        }
        // checkboxGroupInput
        else if (input.hasClass("shiny-input-checkboxgroup")) {
          inputType = "CheckboxGroup";
          var selected = [];
          var selectedEls = input.find("input[type='checkbox']:checked");
          selectedEls.each(function() {
            selected.push($(this).val());
          });
          inputValue = selected.join(",");
        }
        // radioButtons
        else if (input.hasClass("shiny-input-radiogroup")) {
          inputType = "RadioButtons";
          inputValue = input.find("input[type='radio']:checked").val();
        }
        // sliderInput
        else if (input.children(".js-range-slider").length > 0) {
          input = input.children(".js-range-slider");
          inputType = "Slider";
          inputValue = input.attr('data-from');
        }
        // selectInput / selectizeInput
        else if (input.find("select").length > 0) {
          input = input.find("select");
          inputType = "Select";
          inputValue = input.val();
          if (inputValue === null) {
            inputValue = "";
          } else if (inputValue instanceof Array) {
            inputValue = inputValue.join(",");
          }
        }
        // colourInput
        else if (input.children("input.shiny-colour-input").length > 0) {
          input = input.children("input.shiny-colour-input");
          inputType = "Colour";
          inputValue = input.attr('data-init-value');
        }
        // numericInput
        else if (input.children("input[type='number']").length > 0) {
          input = input.children("input[type='number']");
          inputType = "Numeric";
        }
        // textInput
        else if (input.children("input[type='text']").length > 0) {
          input = input.children("input[type='text']");
          inputType = "Text";
        }
        // checkboxInput
        else if (input.find("input[type='checkbox']").length > 0) {
          input = input.find("input[type='checkbox']");
          inputType = "Checkbox";
          inputValue = input.prop('checked');
        }
        // if none of the above, no supported Shiny input was found
        else {
          foundInput = false;
        }

        // if we found a Shiny input, set all the info on it
        if (foundInput) {
          if (inputId === null) {
            inputId = input.attr('id');
          }
          if (inputValue === null) {
            inputValue = input.val();
          }
          input.attr('data-shinyjs-resettable-id', inputId).
                attr('data-shinyjs-resettable-type', inputType).
                attr('data-shinyjs-resettable-value', inputValue).
                addClass('shinyjs-resettable');
        }
      }
  };

  // is an element currently hidden?
  var isHidden = function(el) {
    return el.css("display") === "none";
  };

  // is an element currently disabled?
  var isDisabled = function(el) {
    return el.prop('disabled') === true;
  };

  // if the given HTML tag is a shiny input, return the input container.
  // otherwise, return the original tag
  var getContainer = function(els) {
    return $.map(els, function(el) {
      el = $(el);
      var inputContainer = el.closest(".shiny-input-container");
      if (inputContainer.length > 0) {
        el = inputContainer;
      }
      return el;
    });
  };

  // given a function parameters with several different ways to get DOM
  // elements, retrieve the correct ones
  var getElements = function(params) {
    var $els = null;
    if (params.elements !== null && typeof params.elements !== "undefined") {
      $els = params.elements;
    } else if (params.id !== null && typeof params.id !== "undefined") {
      $els = jqid(params.id);
    } else if (params.selector !== null && typeof params.selector !== "undefined") {
      $els = $(params.selector);
    }
    if ($els === null || $els === undefined || $els.length == 0) {
      console.log("shinyjs: Could not find DOM element");
      console.log(params);
      $els = null;
    }
    return $els;
  };

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
      initResettables();
      initDisabled();
      shinyjs.init();
    },

    // the init function should not be implemented here, it is a placeholder
    // so that users can define their own `shinyjs.init` function (using extendShinyjs)
    // that will be run when the page is initialized
    init : function() {},

    // -----------------------------------------------------------------
    // ------ All functions below are exported shinyjs function --------
    // The documentation for function foo is available in R via ?shinyjs::foo

    show : function (params) {
      var defaultParams = {
        id       : null,
        anim     : false,
        animType : "slide",
        time     : 0.5,
        selector : null,
        elements : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var $els = getElements(params);
      if ($els === null) return;

      // for input elements, hide the whole container, not just the input
      $els = getContainer($els);

      if (!params.anim) {
        $.map($els, function(el) {
          $(el).show();
        });
      } else {
        if (params.animType == "fade") {
          $.map($els, function(el) {
            $(el).fadeIn(params.time * 1000);
          });
        } else {
          $.map($els, function(el) {
            $(el).slideDown(params.time * 1000);
          });
        }
      }

      // If an element was initially hidden when app started, tell shiny that
      // it's now visible so that it can properly render dynamic elements
      $.map($els, function(el) {
        if ($(el).hasClass("shinyjs-hidden-init")) {
          $(el).trigger("shown");
          $(el).removeClass("shinyjs-hidden-init");
        }
      });
    },

    hide : function (params) {
      var defaultParams = {
        id       : null,
        anim     : false,
        animType : "slide",
        time     : 0.5,
        selector : null,
        elements : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var $els = getElements(params);
      if ($els === null) return;

      // for input elements, hide the whole container, not just the input
      $els = getContainer($els);

      if (!params.anim) {
        $.map($els, function(el) {
          $(el).hide();
        });
      } else {
        if (params.animType == "fade") {
          $.map($els, function(el) {
            $(el).fadeOut(params.time * 1000);
          });
        } else {
          $.map($els, function(el) {
            $(el).slideUp(params.time * 1000);
          });
        }
      }
    },

    toggle : function (params) {
      var defaultParams = {
        id        : null,
        anim      : false,
        animType  : "slide",
        time      : 0.5,
        selector  : null,
        condition : null
      };
      params = shinyjs.getParams(params, defaultParams);

      // if there is no condition, then hide/show each element based on whether
      // it is currently shown or hidden
      if (params.condition === null) {
        var $els = getElements(params);
        if ($els === null) return;

        // for input elements, toggle the whole container, not just the input
        $els = getContainer($els);

        $.map($els, function(el) {
          params.elements = $(el);
          isHidden($(el)) ? shinyjs.show(params) : shinyjs.hide(params);
        });
      }
      else if (params.condition) {
        shinyjs.show(params);
      } else {
        shinyjs.hide(params);
      }
    },

    addClass : function (params) {
      var defaultParams = {
        id       : null,
        class    : null,
        selector : null,
        elements : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var $els = getElements(params);
      if ($els === null) return;

      $els.addClass(params.class);
    },

    removeClass : function (params) {
      var defaultParams = {
        id       : null,
        class    : null,
        selector : null,
        elements : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var $els = getElements(params);
      if ($els === null) return;

      $els.removeClass(params.class);
    },

    toggleClass : function (params) {
      var defaultParams = {
        id        : null,
        class     : null,
        condition : null,
        selector  : null
      };
      params = shinyjs.getParams(params, defaultParams);

      // it there is no condition, add/remove class based on current state
      if (params.condition === null) {
        var $els = getElements(params);
        if ($els === null) return;

        $.map($els, function(el) {
          params.elements = $(el);
          $(el).hasClass(params.class) ? shinyjs.removeClass(params) : shinyjs.addClass(params);
        });
      }
      else if (params.condition) {
        shinyjs.addClass(params);
      } else {
        shinyjs.removeClass(params);
      }
    },

    enable : function (params) {
      var defaultParams = {
        id       : null,
        selector : null,
        elements : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var $els = getElements(params);
      if ($els === null) return;

      $.map($els, function(el) {
        var $el = $(el);

        // selectize and slider inputs need special javascript
        if ($el.hasClass("selectized")) {
          $el.selectize()[0].selectize.enable();
        } else if ($el.hasClass("js-range-slider")) {
          $el.data("ionRangeSlider").update({ disable : false });
        }
        // for colour inputs, we want to enable all input fields
        else if ($el.hasClass("shiny-colour-input")) {
          $el = $(getContainer($el)[0]);
        }

        // enable the container as well as all individual inputs inside
        // (this is needed for grouped inputs such as radio and checkbox groups)
        $el = $($el.toArray().concat($el.find("input").toArray()));
        $el.attr('disabled', false);
        $el.prop('disabled', false);
      });
    },

    disable : function (params) {
      var defaultParams = {
        id       : null,
        selector : null,
        elements : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var $els = getElements(params);
      if ($els === null) return;

      $.map($els, function(el) {
        var $el = $(el);

        // selectize and slider inputs need special javascript
        if ($el.hasClass("selectized")) {
          $el.selectize()[0].selectize.disable();
        } else if ($el.hasClass("js-range-slider")) {
          $el.data("ionRangeSlider").update({ disable : true });
        }
        // for colour inputs, we want to disable all input fields
        else if ($el.hasClass("shiny-colour-input")) {
          $el = $(getContainer($el)[0]);
        }

        // disable the container as well as all individual inputs inside
        // (this is needed for grouped inputs such as radio and checkbox groups)
        $el = $($el.toArray().concat($el.find("input").toArray()));
        $el.attr('disabled', true);
        $el.prop('disabled', true);
      });
    },

    toggleState : function (params) {
      var defaultParams = {
        id        : null,
        condition : null,
        selector  : null
      };
      params = shinyjs.getParams(params, defaultParams);

      // it there is no condition, enable/disable based on current state
      if (params.condition === null) {
        var $els = getElements(params);
        if ($els === null) return;

        $.map($els, function(el) {
          params.elements = $(el);
          isDisabled($(el)) ? shinyjs.enable(params) : shinyjs.disable(params);
        });
      }
      else if (params.condition) {
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
        jqid(params.id)[0].innerHTML += params.text;
      } else {
        jqid(params.id)[0].innerHTML = params.text;
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

    runjs : function (params) {
      var defaultParams = {
        code : null
      }
      params = shinyjs.getParams(params, defaultParams);

      eval(params.code);
    },

    // onevent function is more complicated than the rest of the shinyjs functions
    // we attach an event handler (onclick/onkeydown/onmouseup/etc) to an element
    // and when it happens we call Shiny
    onevent : function (params) {
      var defaultParams = {
        event        : null,
        id           : null,
        shinyInputId : null,
        add          : false
      }
      params = shinyjs.getParams(params, defaultParams);

      var el = jqid(params.id);

      // for shiny inputs, perform the action when the event happens in any
      // section of the input widget
      el = $(getContainer(el)[0]);

      var shinyInputId = params.shinyInputId;
      var attrName = "data-shinyjs-" + params.event;

      // if this is the first event handler of this event type we attach to this
      // element, initialize the data attribute and add the event handler
      var first = !(el[0].hasAttribute(attrName));
      if (first) {
        el.attr(attrName, JSON.stringify(Object()));

        el[params.event](function() {
          var oldValues = JSON.parse(el.attr(attrName));
          var newValues = Object();
          $.each(oldValues, function(key, value) {
            var newValue = value + 1;
            newValues[key] = newValue;
            Shiny.onInputChange(key, newValue);
          });
          el.attr(attrName, JSON.stringify(newValues));
        });
      }

      // if we want this action to overwrite existing ones, unbind event handler
      if (params.add) {
        var attrValue = JSON.parse(el.attr(attrName));
      } else {
        var attrValue = Object();
      }
      attrValue[shinyInputId] = 0;
      el.attr(attrName, JSON.stringify(attrValue));
    },

    // the reset function is also complicated because we need R to tell us
    // what input element or form to reset, then the javascript needs to
    // figure out the correct type and initial value for each input and pass
    // that info back to R so that R can call the correct shiny::updateFooInput()
    reset : function(params) {
      var defaultParams = {
        id : null,
        shinyInputId : null
      }
      params = shinyjs.getParams(params, defaultParams);

      var el = jqid(params.id);

      // find all the resettable input elements
      var resettables;
      if (el.hasClass("shinyjs-resettable")) {
        resettables = el;
      } else {
        resettables = el.find(".shinyjs-resettable");
      }

      // go through each input and record its id, type, and initial value
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

      // send a message back to R with the info for each input element
      Shiny.onInputChange(params.shinyInputId, messages);
    },

   // run an R function after an asynchronous delay
   delay : function(params) {
      var defaultParams = {
        ms : null,
        shinyInputId : null
      }
      params = shinyjs.getParams(params, defaultParams);

      // send a message back to R when the delay is up
      setTimeout(function() {
        Shiny.onInputChange(params.shinyInputId, params.ms);
      }, params.ms);
   }
  };
}();

// Initialize shinyjs on the JS side
$(function() { shinyjs.initShinyjs(); });

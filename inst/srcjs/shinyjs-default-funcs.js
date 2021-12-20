// shinyjs 2.1.0 by Dean Attali
// Perform common JavaScript operations in Shiny apps using plain R code

shinyjs = function() {

  // --------------------------------
  // ------ Private variables -------

  // store the event handlers for the onevent function when it's called on
  // elements that do not exist yet in the document
  var _oneventData = {};

  // some functions need to work with dynamically generated elements, so they
  // can add themselves to this list and will be called whenever the DOM is mutated
  var _mutationSubscribers = [];

  // ---------------------------------------
  // ------ General helper functions -------

  // get an element by id using JQuery (escape chars that have special
  // selector meaning)
  var _jqid = function(id) {
    return $("#" + id.replace( /(:|\.|\[|\]|,|\s)/g, "\\$1" ));
  };

  // listen to DOM changes and whenever there are new nodes added, let all
  // the mutation subscribers know about the new elements
  var _initMutations = function() {
    var canObserveMutation = 'MutationObserver' in window;
    if (canObserveMutation) {
      var mutationCallback = function(mutations) {
        mutations.forEach(function(mutation) {
          $.each(mutation.addedNodes, function(idx, node) {
            $.each(_mutationSubscribers, function(idx, fxn) {
              // call the subscriber on each new node
              fxn(node);
            });
          });
        });
      };
      var observer = new MutationObserver(mutationCallback);
      observer.observe(document.body, { childList : true, subtree : true });
    }
  };

  // if the given HTML tag is a shiny input, return the input container.
  // otherwise, return the original tag
  var _getContainer = function(els) {
    return $.map(els, function(el) {
      el = $(el);
      if (el.hasClass("shiny-bound-input")) {
        var inputContainer = el.closest(".shiny-input-container");
        if (inputContainer.length > 0) {
          el = inputContainer;
        }
      }
      return el;
    });
  };

  // given a function parameters with several different ways to get DOM
  // elements, retrieve the correct ones
  var _getElements = function(params) {
    var $els = null;
    if (params.elements !== null && typeof params.elements !== "undefined") {
      $els = params.elements;
    } else if (params.id !== null && typeof params.id !== "undefined") {
      $els = _jqid(params.id);
    } else if (params.selector !== null && typeof params.selector !== "undefined") {
      $els = $(params.selector);
    }
    if ($els === null || $els === undefined || $els.length == 0) {
      shinyjs.debugMessage("shinyjs: Could not find DOM element using these parameters:");
      shinyjs.debugMessage(params);
      $els = null;
    }
    return $els;
  };

  // -----------------------------------
  // ------ Helpers for `toggle` -------

  // is an element currently hidden?
  var _isHidden = function(el) {
    return el.css("display") === "none";
  };

  // ----------------------------------------
  // ------ Helpers for `toggleState` -------

  // is an element currently disabled?
  var _isDisabled = function(el) {
    return el.prop('disabled') === true;
  };

  // -------------------------------------
  // ------ Helpers for `disabled` -------

  // disable all the elements that were initialized as disabled
  var _initDisabled = function() {
    // disable elements on page load
    _initDisabledHelper($(".shinyjs-disabled"));

    // disable new elements being added to the document
    _mutationSubscribers.push(function(node) {
      _initDisabledHelper($(node).find(".shinyjs-disabled"));
      if ($(node).is(".shinyjs-disabled")) {
        _initDisabledHelper($(node));
      }
    });
  };

  var _initDisabledHelper = function(els) {
    if (els.length == 0) return;

    // use a tiny delay because some input elements (sliders, selectize) need
    // to first be initialized, and I don't know how to tell when they're ready
    setTimeout(function() {
      // disable elements
      shinyjs.disable({ elements : els });
    }, 10);
  };

  // ----------------------------------------
  // ------ Helpers for `show`/`hide` -------

  var _showHide = function(method, params) {
    var defaultParams = {
      id       : null,
      anim     : false,
      animType : "slide",
      time     : 0.5,
      selector : null,
      elements : null
    };
    params = shinyjs.getParams(params, defaultParams);

    var $els = _getElements(params);
    if ($els === null) return;

    // for input elements, hide the whole container, not just the input
    $els = _getContainer($els);

    // if an element was hidden on page load, remove that flag
    $.map($els, function(el) {
      if ($(el).hasClass("shinyjs-hide")) {
        $(el).removeClass("shinyjs-hide");
        $(el).hide();
      }
    });

    if (!params.anim) {
      $.map($els, function(el) {
        (method == "show") ?
          $(el).show() :
          $(el).hide();
      });
    } else {
      if (params.animType == "fade") {
        $.map($els, function(el) {
          (method == "show") ?
            $(el).fadeIn(params.time * 1000) :
            $(el).fadeOut(params.time * 1000);
        });
      } else {
        $.map($els, function(el) {
          (method == "show") ?
            $(el).slideDown(params.time * 1000) :
            $(el).slideUp(params.time * 1000);
        });
      }
    }

    // If an element was initially hidden when app started, tell shiny that
    // it's now visible so that it can properly render dynamic elements
    $.map($els, function(el) {
      $(el).trigger(method == "show" ? "shown" : "hidden");
    });
  };

  // ---------------------------------------------------
  // ------ Helpers for `addClass`/`removeClass` -------

  var _addRemoveClass = function(method, params) {
    var defaultParams = {
      id       : null,
      class    : null,
      selector : null,
      elements : null
    };
    params = shinyjs.getParams(params, defaultParams);

    var $els = _getElements(params);
    if ($els === null) return;

    (method == "add") ?
      $els.addClass(params.class) :
      $els.removeClass(params.class);
  };

  // ---------------------------------------------------
  // ------ Helpers for `enable`/`disable` -------------

  var _enableDisable = function(method, params) {
    var defaultParams = {
      id       : null,
      selector : null,
      elements : null
    };
    params = shinyjs.getParams(params, defaultParams);

    var $els = _getElements(params);
    if ($els === null) return;

    // make sure we take special care of elements that need to be specifically
    // enabled with special javascript
    var toadd = $els.find(".selectized, .js-range-slider");
    $els = $($els.toArray().concat(toadd.toArray()));

    $.map($els, function(el) {
      var $el = $(el);

      // selectize and slider inputs need special javascript
      if ($el.hasClass("selectized")) {
        (method == "enable") ?
          $el.selectize()[0].selectize.enable() :
          $el.selectize()[0].selectize.disable();
      } else if ($el.hasClass("js-range-slider")) {
        $el.data("ionRangeSlider").update({ disable : (method == "disable") });
      }
      // for colour inputs, we want to enable/disable all input fields
      else if ($el.hasClass("shiny-colour-input")) {
        $el = $(_getContainer($el)[0]);
      }

      // enable/disable the container as well as all individual inputs inside
      // (this is needed for grouped inputs such as radio and checkbox groups)
      var toadd = $el.find("input, button, textarea, select, a[download]");
      $el = $($el.toArray().concat(toadd.toArray()));
      $el.attr('disabled', (method == "disable"));
      $el.prop('disabled', (method == "disable"));
      method == "disable" ? $el.addClass("disabled") : $el.removeClass("disabled");
    });
  };

  // ----------------------------------
  // ------ Helpers for `reset` -------

  // find all shiny input elements and set them up to allow them to be reset
  var _initResettables = function() {
    // grab all the shiny input containers that exist when the app loads
    _initResettablesHelper($(".shiny-input-container"));

    // observer new elements added to the document so that dynamically generated
    // elements can also be resettable
    _mutationSubscribers.push(function(node) {
      _initResettablesHelper($(node).find(".shiny-input-container"));
      if ($(node).is(".shiny-input-container")) {
        _initResettablesHelper($(node));
      }
    });
  };

  // helper function to get the initial date from a bootstrap date element
  // if there is no initial date, return the current date
  var _getInputDate = function(el) {
    if (el[0].hasAttribute('data-initial-date')) {
      if (el.attr('data-initial-date') === "") {
        return 'NA';
      } else {
        return el.attr('data-initial-date');
      }
    }
    var today = new Date();
    var yyyy = today.getFullYear().toString();
    var mm = (today.getMonth() + 1).toString();
    var dd  = today.getDate().toString();
    return yyyy + '-' + (mm[1]?mm:"0"+mm[0]) + '-' + (dd[1]?dd:"0"+dd[0]);
  };

  // go through every Shiny input and based on what kind of input it is,
  // add some information to the HTML tag so that we can know how to
  // update it back to its original value
  var _initResettablesHelper = function(els) {
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
          inputValue = _getInputDate(input);
          inputId = inputContainer.attr('id');
        }
        // dateRangeInput
        else if (input.hasClass("shiny-date-range-input")) {
          inputType = "DateRange";
          inputValue = _getInputDate($(input.find("input")[0])) + "," +
                       _getInputDate($(input.find("input")[1]));
        }
        // checkboxGroupInput
        else if (input.hasClass("shiny-input-checkboxgroup")) {
          inputType = "CheckboxGroup";
          var selected = [];
          var selectedEls = input.find("input[type='checkbox']:checked");
          selectedEls.each(function() {
            selected.push($(this).val());
          });
          inputValue = JSON.stringify(selected);
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
          if (typeof input.attr('data-from') !== "undefined") {
            inputValue = input.attr('data-from');
          }
          if (typeof input.attr('data-to') !== "undefined") {
            inputValue = inputValue + "," + input.attr('data-to');
          }
        }
        // selectInput / selectizeInput
        else if (input.find("select").length > 0) {
          input = input.find("select");
          inputType = "Select";
          inputValue = input.val();
          if (inputValue === null) {
            inputValue = "";
          }
          inputValue = JSON.stringify(inputValue);
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
        // passwordInput
        else if (input.children("input[type='password']").length > 0) {
          input = input.children("input[type='password']");
          inputType = "Password";
        }
        // textAreaInput
        else if (input.children("textarea").length > 0) {
          input = input.children("textarea");
          inputType = "TextArea";
        }
        else if (input.find("input[type='file']").length > 0) {
          input = input.find("input[type='file']");
          inputType = "File"
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

  // ------------------------------------
  // ------ Helpers for `onevent` -------

  // ensure that the onevent function works for dynamic elements
  var _initOnevent = function() {
    // for every new node in the DOM, check if there is an ID that was registered
    // with `onevent` for a dynamic element that corresponds to a node that was
    // just created. If so, find out what events were registered to it and the
    // shiny event handlers for it, and attach them
    _mutationSubscribers.push(function(node) {
      // check the top node
      var $node = $(node);
      var id = $node.attr("id");
      _eventsAttachById(id);
      // check all descendants
      $node.find("*").each(function() {
        var id = $(this).attr("id");
        _eventsAttachById(id);
      });
    });
  };

  // Attach all events registered for a given id (if any)
  var _eventsAttachById = function(id) {
    var elementData = _oneventData[id];
    if (elementData !== null) {
      $.each(elementData, function(event, eventDatas) {
        $.each(eventDatas, function(idx, eventData) {
          _oneventAttach({
            event        : event,
            id           : id,
            shinyInputId : eventData.shinyInputId,
            add          : true,
            customProps  : eventData.customProps
          });
        });
      });
    }
  };

  // attach an event listener to a DOM element that will trigger a call to Shiny
  var _oneventAttach = function(params) {
    var el = _jqid(params.id);

    // for shiny inputs, perform the action when the event happens in any
    // section of the input widget
    el = $(_getContainer(el)[0]);

    var shinyInputId = params.shinyInputId;
    var attrName = "data-shinyjs-" + params.event;

    // if this is the first event handler of this event type we attach to this
    // element, initialize the data attribute and add the event handler
    var first = !(el[0].hasAttribute(attrName));
    if (first) {
      el.attr(attrName, JSON.stringify(Object()));

      el[params.event](function(event) {
        // Store a subset of the event properties (many are non-serializeable)
        var props = ['altKey', 'button', 'buttons', 'clientX', 'clientY',
          'ctrlKey', 'pageX', 'pageY', 'screenX', 'screenY', 'shiftKey',
          'which', 'charCode', 'key', 'keyCode', 'offsetX', 'offsetY'];
        props = props.concat(params.customProps);
        var eventSimple = {};
        $.each(props, function(idx, prop) {
          if (prop in event) {
            eventSimple[prop] = event[prop];
          }
        });
        eventSimple.shinyjsRandom = Math.random();

        var oldValues = JSON.parse(el.attr(attrName));
        var newValues = Object();
        $.each(oldValues, function(key, value) {
          var newValue = value + 1;
          newValues[key] = newValue;
          Shiny.onInputChange(key, eventSimple);
        });

        el.attr(attrName, JSON.stringify(newValues));
      });
    }

    // if we want this action to overwrite existing ones, unbind event handler
    if (params.add) {
      var attrValue = JSON.parse(el.attr(attrName));
    } else {
      var attrValue = {};
    }
    attrValue[shinyInputId] = 0;
    el.attr(attrName, JSON.stringify(attrValue));
  };

  return {

    // by default, debug mode is off. If shinyjs is initialized with debug mode,
    // then debugging messages will be printed to the console
    debug : false,

    // write a message to the console for debugging purposes if debug mode is on
    debugMessage : function(text) {
      if (shinyjs.debug) {
        console.info(text);
      }
    },

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

    // this function gets called once (automatically) to initialize shinyjs
    initShinyjs : function() {
      _initMutations();
      _initResettables();
      _initDisabled();
      _initOnevent();
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
      _showHide("show", params);
    },

    hide : function (params) {
      _showHide("hide", params);
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
        var $els = _getElements(params);
        if ($els === null) return;

        // for input elements, toggle the whole container, not just the input
        $els = _getContainer($els);

        $.map($els, function(el) {
          params.elements = $(el);
          _isHidden($(el)) ? shinyjs.show(params) : shinyjs.hide(params);
        });
      }
      else if (params.condition) {
        shinyjs.show(params);
      } else {
        shinyjs.hide(params);
      }
    },

    addClass : function (params) {
      _addRemoveClass("add", params);
    },

    removeClass : function (params) {
      _addRemoveClass("remove", params);
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
        var $els = _getElements(params);
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
      _enableDisable("enable", params);
    },

    disable : function (params) {
      _enableDisable("disable", params);
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
        var $els = _getElements(params);
        if ($els === null) return;

        $.map($els, function(el) {
          params.elements = $(el);
          _isDisabled($(el)) ? shinyjs.enable(params) : shinyjs.disable(params);
        });
      }
      else if (params.condition) {
        shinyjs.enable(params);
      } else {
        shinyjs.disable(params);
      }
    },

    html : function (params) {
      var defaultParams = {
        id       : null,
        html     : null,
        add      : false,
        selector : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var $els = _getElements(params);
      if ($els === null) return;

      $.each($els, function(idx, node) {
        if (params.add) {
          node.innerHTML += params.html;
        } else {
          node.innerHTML = params.html;
        }
      });
    },

    alert : function (params) {
      var defaultParams = {
        text : null
      }
      params = shinyjs.getParams(params, defaultParams);

      if (typeof params.text == "object") {
        alert(JSON.stringify(params.text, null, 4));
      } else {
        alert(params.text);
      }

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
        add          : false,
        customProps  : []
      }
      params = shinyjs.getParams(params, defaultParams);

      var el = _jqid(params.id);

      // if element does not exist in the document, save the information so that
      // if the element is created dynamically later, we can add the handlers
      if (el.length == 0) {
        if (!(params.id in _oneventData)) {
          _oneventData[params.id] = {};
        }
        var elementData = _oneventData[params.id];
        if (!(params.event in elementData) || !params.add) {
          elementData[params.event] = [];
        }
        elementData[params.event].push({
          "shinyInputId" : params.shinyInputId,
          "customProps"  : params.customProps
        });
      }
      // if the element does exist, add the event handler
      else {
        _oneventAttach(params);
      }
    },

    removeEvent : function (params) {
      var defaultParams = {
        event        : null,
        id           : null
      }
      params = shinyjs.getParams(params, defaultParams);

      var el = _jqid(params.id);

      var eventInstance = params.event;
      var eventType = eventInstance.replace(/(.*)-/,"");
      var removeAll = (eventInstance == eventType);

      // If the element is not yet in the document, remove it from the onevent queue
      if (el.length == 0) {
        if (params.id in _oneventData) {
          var elementData = _oneventData[params.id];
          if (removeAll) {
            delete elementData[eventType];
          } else {
            if (eventType in elementData) {
              var eventDatas = elementData[eventType];
              var newEvents = eventDatas.filter(function(data) {
                return data.shinyInputId != eventInstance;
              });
              if (newEvents.length == 0) {
                delete elementData[eventType];
              } else {
                elementData[eventType] = newEvents;
              }
            }
          }
        }
      } else {
        var attrName = "data-shinyjs-" + eventType;
        if (el[0].hasAttribute(attrName)) {
          if (removeAll) {
            var attrValue = {};
          } else {
            var attrValue = JSON.parse(el.attr(attrName));
            delete attrValue[eventInstance]
          }
          el.attr(attrName, JSON.stringify(attrValue));
        }
      }
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

      if (params.id === "") {
        var el = $("body");
      } else {
        var el = _jqid(params.id);
      }

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
          // file inputs need to be reset manually since shiny doesn't have an
          // update function for them
          if (type == "File") {
            _jqid(id).val('');
            _jqid(id + "_progress").css("visibility", "hidden");
            _jqid(id + "_progress").find(".progress-bar").css("width", "0");
            _jqid(id).closest(".input-group").find("input[type='text']").val('');
          } else {
            messages[id] = { 'type' : type, 'value' : value };
          }
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
    },

    // click on a button
    click : function(params) {
      var defaultParams = {
        id : null
      };
      params = shinyjs.getParams(params, defaultParams);

      var $el = _getElements(params);
      if ($el === null) return;
      $el[0].click();
    },

    // refresh the page
    refresh : function(params) {
      var defaultParams = {
        id : null
      };
      params = shinyjs.getParams(params, defaultParams);

      window.location.reload(false);
    }
  };
}();

// Initialize shinyjs on the JS side
$(function() { shinyjs.initShinyjs(); });

// ShinySenderQueue code taken from Joe Cheng
// https://github.com/rstudio/shiny/issues/1476
function ShinySenderQueue() {
  this.readyToSend = true;
  this.queue = [];
  this.timer = null;
}
ShinySenderQueue.prototype.send = function(name, value) {
  var self = this;
  function go() {
    self.timer = null;
    if (self.queue.length) {
      var msg = self.queue.shift();
      if (typeof Shiny === 'object' && typeof Shiny.compareVersion === 'function' &&
          Shiny.compareVersion(Shiny.version, '>=', '1.1.0')) {
        Shiny.setInputValue(msg.name, msg.value, {priority: "event"});
      } else {
        Shiny.onInputChange(msg.name, msg.value);
      }
      self.timer = setTimeout(go, 0);
    } else {
      self.readyToSend = true;
    }
  }
  if (this.readyToSend) {
    this.readyToSend = false;
    if (typeof Shiny === 'object' && typeof Shiny.compareVersion === 'function' &&
        Shiny.compareVersion(Shiny.version, '>=', '1.1.0')) {
      Shiny.setInputValue(name, value, {priority: "event"});
    } else {
      Shiny.onInputChange(name, value);
    }
    this.timer = setTimeout(go, 0);
  } else {
    this.queue.push({name: name, value: value});
    if (!this.timer) {
      this.timer = setTimeout(go, 0);
    }
  }
};

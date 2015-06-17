var colourBinding = new Shiny.InputBinding();
$.extend(colourBinding, {
  find: function(scope) {
    // Check if colour plugin is loaded
    if (!$.fn.colorPicker)
      return [];
    return $(scope).find('input.shiny-colour-input');
  },
  getValue: function(el) {
    return $(el).val();
  },
  setValue: function(el, value) {
    // change the text colour and background colour as well as the actual value
    $(el).val(value).
    css("background-color", value).
    css("color", this._getTextCol(value));
  },
  subscribe: function(el, callback) {
    // I'm using "shinychange" instead of "change" to not get into an infinite loop
    $(el).on("shinychange.colourBinding", function(e) {
    callback(true);
    });
  },
    unsubscribe: function(el) {
    $(el).off(".colourBinding");
    },
    initialize : function(el) {
    $el = $("#" + el.id);  // for some reason using $(el) doesn't work
    
    var opts = {
      opacity : false,    // don't allow transparency control
      animationSpeed : 0, // don't animate
      cssAddon : '.cp-xy-slider:active { cursor : none; }',  // hide cursor
      renderCallback : function($el) {  // write the colour value in the box
        $el.val('#' + this.color.colors.HEX);
        $el.trigger("shinychange");
      },
    };
    
    // initialize the colour picker
    $el.colorPicker(opts);
    
    // set default value
    this.setValue(el, $el.attr('data-init-col'));
    this._setShowColour($el, $el.attr('data-show-colour'));
    },
  // update the colour input
  receiveMessage: function(el, data) {
    var $el = $(el);
    
    if (data.hasOwnProperty('value')) {
      this.setValue(el, data.value);
    }
    if (data.hasOwnProperty('label')) {
      $el.parent().find('label[for="' + el.id + '"]').text(data.label);
    }
    if (data.hasOwnProperty('showColour')) {
      this._setShowColour($el, data.showColour);    
    }
    
    $el.trigger("shinychange");
  },
  getRatePolicy : function() {
    return {
      policy: 'debounce',
      delay: 250
    };
  },
  // set whether to show the colour as the text/background/both
  _setShowColour : function($el, showColour) {
    $el.removeClass("nobg").removeClass("notext");
    if (showColour == "text") {
      $el.addClass("nobg");
    } else if (showColour == "background") {
      $el.addClass("notext");
    }
  },
  // get the text colour to use inside the box if the background interferes with it
  _getTextCol : function(hex) {
    var luminance = this._getLuminance(hex);
    return luminance > 0.22 ? '#222' : '#ddd';
  },
  // calculate the luminance of the chosen colour to determine if too dark for text
  _getLuminance : function(hex) {
    var rgb = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
      rgb = $.map(rgb.slice(1), function(x) {
        x = parseInt(x, 16) / 255;
        x = x <= 0.03928 ? x / 12.92 : Math.pow(((x + 0.055) / 1.055), 2.4);
        return x;
      });
      var luminance = rgb[0]*0.2126 + rgb[1]*0.7152 + rgb[2]*0.0722;
      return luminance;
  }
  });

Shiny.inputBindings.register(colourBinding);
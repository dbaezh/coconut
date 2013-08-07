// Generated by CoffeeScript 1.6.2
var ScanBarcodeView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ScanBarcodeView = (function(_super) {
  __extends(ScanBarcodeView, _super);

  function ScanBarcodeView() {
    this.render = __bind(this.render, this);    _ref = ScanBarcodeView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ScanBarcodeView.prototype.el = '#content';

  ScanBarcodeView.prototype.events = {
    "change .client": "onChange"
  };

  ScanBarcodeView.prototype.render = function() {
    this.$el.html("      <style>      #feedback      {        color: #cc0000;      }      .client      {        text-transform: uppercase;      }      </style>      <h1>Find/Create Client</h1>          <span id='feedback'></span>      <br>      <div>        <label for='client_1'>Client ID</label>        <input class='client' id='client_1' type='text'>      </div>      <div>        <label for='client_2'>Confirm client ID</label>        <input class='client' id='client_2' type='text'>      </div>    ");
    $("input").textinput();
    return $("head title").html("Coconut Find/Create Client");
  };

  ScanBarcodeView.prototype.onChange = function() {
    var client1, client2, _ref1, _ref2;

    client1 = ($("#client_1").val() || '').toUpperCase();
    client2 = ($("#client_2").val() || '').toUpperCase();
    if (((_ref1 = client1.match(/-/g)) != null ? _ref1.length : void 0) !== 2) {
      client1 = client1.replace(/^(.)(.)(.)/, "$1-$2-$3");
      $("#client_1").val(client1);
    }
    if (((_ref2 = client2.match(/-/g)) != null ? _ref2.length : void 0) !== 2) {
      client2 = client2.replace(/^(.)(.)(.)/, "$1-$2-$3");
      $("#client_2").val(client2);
    }
    if (client1 !== "" && client2 !== "") {
      if (client1 !== client2) {
        return $("#feedback").html("Client IDs do not match");
      } else {
        Coconut.loginView.callback = {
          success: function() {
            $("head title").html("Coconut");
            return Coconut.router.navigate("/summary/" + client1, true);
          }
        };
        return Coconut.loginView.render();
      }
    }
  };

  return ScanBarcodeView;

})(Backbone.View);

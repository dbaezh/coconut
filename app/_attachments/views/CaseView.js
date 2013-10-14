// Generated by CoffeeScript 1.6.2
var CaseView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CaseView = (function(_super) {
  __extends(CaseView, _super);

  function CaseView() {
    this.render = __bind(this.render, this);    _ref = CaseView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CaseView.prototype.el = '#content';

  CaseView.prototype.render = function() {
    var _this = this;

    return this.$el.html("      <h1>Case ID: " + (this["case"].MalariaCaseID()) + "</h1>      <h2>Last Modified: " + (this["case"].LastModifiedAt()) + "</h2>      <h2>Questions: " + (this["case"].Questions()) + "</h2>      " + (_.map("region,district,constituan,ward".split(","), function(locationType) {
      return "<h2>" + (locationType.humanize()) + ": " + (_this["case"].location(locationType)) + "</h2>";
    }).join("")) + "      <pre>      " + (JSON.stringify(this["case"].toJSON(), null, 4)) + "      </pre>    ");
  };

  return CaseView;

})(Backbone.View);

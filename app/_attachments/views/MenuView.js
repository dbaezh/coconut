// Generated by CoffeeScript 1.6.2
var MenuView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MenuView = (function(_super) {
  __extends(MenuView, _super);

  function MenuView() {
    this.checkReplicationStatus = __bind(this.checkReplicationStatus, this);
    this.render = __bind(this.render, this);    _ref = MenuView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  MenuView.prototype.el = '.question-buttons';

  MenuView.prototype.events = {
    "change": "render"
  };

  MenuView.prototype.render = function() {
    var _this = this;

    this.updateVersion();
    this.checkReplicationStatus();
    if ("module" === Coconut.config.local.get("mode")) {
      return;
    }
    this.$el.html("      <div id='navbar' data-role='navbar'>        <ul></ul>      </div>    ");
    return Coconut.questions.fetch({
      success: function() {
        _this.$el.find("ul").html("          <li>            <a id='menu-retrieve-client' href='#new/result'>              <h2>Find/Create Client<div id='menu-partial-amount'>&nbsp;</div></h2>            </a>          </li> ");
        _this.$el.find("ul").append(Coconut.questions.map(function(question, index) {
          return "<li><a id='menu-" + index + "' class='menu-" + index + "' href='#show/results/" + (escape(question.id)) + "'><h2>" + question.id + "<div id='menu-partial-amount'></div></h2></a></li>";
        }).join(" "));
        $(".question-buttons").navbar();
        Coconut.questions.each(function(question, index) {
          return $(".menu-" + index).addClass('ui-disabled');
        });
        return _this.update();
      }
    });
  };

  MenuView.prototype.updateVersion = function() {
    return $.ajax("version", {
      success: function(result) {
        return $("#version").html(result);
      },
      error: $("#version").html("-")
    });
  };

  MenuView.prototype.update = function() {
    var _this = this;

    Coconut.questions.each(function(question, index) {
      var results;

      results = new ResultCollection();
      return results.fetch({
        include_docs: false,
        question: question.id,
        isComplete: false,
        success: function() {
          return $("#menu-" + index + " #menu-partial-amount").html(results.length);
        }
      });
    });
    return this.updateVersion();
  };

  MenuView.prototype.checkReplicationStatus = function() {
    var _this = this;

    return $.couch.login({
      name: Coconut.config.get("local_couchdb_admin_username"),
      password: Coconut.config.get("local_couchdb_admin_password"),
      error: function() {
        return console.log("Could not login");
      },
      complete: function() {
        return $.ajax({
          url: "/_active_tasks",
          dataType: 'json',
          success: function(response) {
            var progress, _ref1;

            progress = response != null ? (_ref1 = response[0]) != null ? _ref1.progress : void 0 : void 0;
            if (progress) {
              $("#databaseStatus").html("" + progress + "% Complete");
              return _.delay(_this.checkReplicationStatus, 1000);
            } else {
              console.log("No database status update");
              $("#databaseStatus").html("");
              return _.delay(_this.checkReplicationStatus, 60000);
            }
          },
          error: function(error) {
            console.log("Could not check active_tasks: " + (JSON.stringify(error)));
            return _.delay(_this.checkReplicationStatus, 60000);
          }
        });
      }
    });
  };

  return MenuView;

})(Backbone.View);

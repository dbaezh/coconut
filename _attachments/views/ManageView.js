// Generated by CoffeeScript 1.6.2
var ManageView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ManageView = (function(_super) {
  __extends(ManageView, _super);

  function ManageView() {
    this.render = __bind(this.render, this);    _ref = ManageView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ManageView.prototype.el = '#content';

  ManageView.prototype.render = function() {
    this.$el.html("      <a href='#sync'>Sync</a>      <a href='#configure'>Set cloud vs mobile</a>      <a href='#users'>Manage users</a>      <a href='#messaging'>Send message to users</a>      <h2>Question Sets</h2>      <a href='#design'>New</a>      <table>        <thead>          <th></th>          <th></th>          <th></th>          <th></th>        </thead>        <tbody>        </tbody>      </table>    ");
    $("a").button();
    return Coconut.questions.fetch({
      success: function() {
        Coconut.questions.each(function(question) {
          var questionId, questionName;

          questionName = question.id;
          questionId = escape(question.id);
          return $("tbody").append("            <tr>              <td>" + questionName + "</td>              <td><a href='#edit/" + questionId + "'>edit</a></td>              <td><a href='#delete/" + questionId + "'>delete</a></td>              <td><a href='#edit/resultSummary/" + questionId + "'>summary</a></td>            </tr>          ");
        });
        return $("table a").button();
      }
    });
  };

  return ManageView;

})(Backbone.View);

/*
//@ sourceMappingURL=ManageView.map
*/

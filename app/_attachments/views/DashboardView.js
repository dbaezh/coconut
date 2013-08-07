// Generated by CoffeeScript 1.6.2
var DashboardView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

DashboardView = (function(_super) {
  __extends(DashboardView, _super);

  function DashboardView() {
    this.renderDashboard = __bind(this.renderDashboard, this);
    this.render = __bind(this.render, this);
    this.update = __bind(this.update, this);    _ref = DashboardView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  DashboardView.prototype.el = '#content';

  DashboardView.prototype.events = {
    "change #reportOptions": "update"
  };

  DashboardView.prototype.update = function() {
    var reportOptions, url;

    reportOptions = {
      startDate: $('#start').val(),
      endDate: $('#end').val(),
      reportType: $('#report-type :selected').text()
    };
    _.each(this.locationTypes, function(location) {
      return reportOptions[location] = $("#" + location + " :selected").text();
    });
    url = "dashboard/" + _.map(reportOptions, function(value, key) {
      return "" + key + "/" + (escape(value));
    }).join("/");
    return Coconut.router.navigate(url, true);
  };

  DashboardView.prototype.render = function(options) {
    this.renderOptions(options);
    this.renderDashboard();
    $('div[data-role=fieldcontain]').fieldcontain();
    $('select').selectmenu();
    return $('input[type=date]').datebox({
      mode: "calbox"
    });
  };

  DashboardView.prototype.renderOptions = function(options) {
    this.startDate = options.startDate || moment(new Date).subtract('days', 30).format("YYYY-MM-DD");
    this.endDate = options.endDate || moment(new Date).format("YYYY-MM-DD");
    this.$el.html("      <style>        table.results th.header, table.results td{          font-size:150%;        }      </style>      <table id='reportOptions'></table>      ");
    $("#reportOptions").append(this.formFilterTemplate({
      id: "start",
      label: "Start Date",
      form: "<input id='start' type='date' value='" + this.startDate + "'/>"
    }));
    return $("#reportOptions").append(this.formFilterTemplate({
      id: "end",
      label: "End Date",
      form: "<input id='end' type='date' value='" + this.endDate + "'/>"
    }));
  };

  DashboardView.prototype.formFilterTemplate = function(options) {
    return "      <tr id='row-" + options.id + "' class='" + options.type + "'>        <td>          <label style='display:inline' for='" + options.id + "'>" + options.label + "</label>         </td>        <td style='width:150%'>          " + options.form + "        </td>      </tr>    ";
  };

  DashboardView.prototype.renderDashboard = function() {
    var tableColumns,
      _this = this;

    tableColumns = ["Time of Visit", "User ID", "Client ID", "Location", "Type of Visit"];
    this.$el.append("    <table id='dashboard' class='tablesorter'>      <thead>        <tr>          " + (_.map(tableColumns, function(text) {
      return "<th>" + text + "</th>";
    }).join("")) + "        </tr>      </thead>      <tbody>      </tbody>    </table>    ");
    return this.getClientResults({
      success: function(results) {
        _this.$el.find("#dashboard tbody").append(_.map(results, function(result) {
          return "          <tr>            <td>" + (moment(result.key).format(Coconut.config.get("datetime_format"))) + "</td>            <td>" + (_this.extractUserID(result.doc)) + "</td>            <td>" + (_this.extractClientID(result.doc)) + "</td>            <td>" + (_this.extractLocation(result.doc)) + "</td>            <td>" + (_this.extractTypeOfVisit(result.doc)) + "</td>          </tr>          ";
        }).join(""));
        return $("#dashboard").tablesorter({
          widgets: ['zebra'],
          sortList: [[0, 0]]
        });
      }
    });
  };

  DashboardView.prototype.extractUserID = function(result) {
    if (result.user) {
      return result.user;
    } else if (result.source) {
      return "Unknown";
    }
  };

  DashboardView.prototype.extractClientID = function(result) {
    if (result.question) {
      return result.ClientID;
    } else if (result.source) {
      return result.IDLabel;
    }
  };

  DashboardView.prototype.extractLocation = function(result) {
    if (result.ClinicLocation) {
      return result.ClinicLocation;
    } else {
      return "Unknown";
    }
  };

  DashboardView.prototype.extractTypeOfVisit = function(result) {
    if (result.source) {
      return result.source;
    } else if (result.question) {
      return result.question;
    }
  };

  DashboardView.prototype.getClientResults = function(options) {
    var _this = this;

    return $.couch.db(Coconut.config.database_name()).view("" + (Coconut.config.design_doc_name()) + "/clientsByVisitDate", {
      startkey: moment(this.endDate).endOf("day").format(Coconut.config.get("datetime_format")),
      endkey: this.startDate,
      descending: true,
      include_docs: true,
      success: function(result) {
        return options.success(result.rows);
      }
    });
  };

  return DashboardView;

})(Backbone.View);

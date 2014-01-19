// Generated by CoffeeScript 1.6.3
var OldReportView, ReportView, _ref, _ref1,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ReportView = (function(_super) {
  __extends(ReportView, _super);

  function ReportView() {
    _ref = ReportView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ReportView.prototype.el = "#content";

  ReportView.prototype.events = {
    "keyup #search": "filter"
  };

  ReportView.prototype.getCompletedSurveyUUIDsAndFetch = function() {
    var completedSurveys, db, results, _this;
    results = void 0;
    _this = this;
    completedSurveys = void 0;
    results = new Backbone.Collection;
    results.model = Result;
    results.url = "result";
    db = $.couch.db("coconut");
    return db.view("coconut/byUUIDandQuestion", {
      success: function(data) {
        _this.completedSurveys = data;
        return results.fetch({
          success: function(allResults) {
            var fields;
            fields = void 0;
            console.log(allResults.first());
            window.allResults = allResults;
            console.log("trying to get all from");
            console.log(_this.quid);
            _this.results = allResults.where({
              question: _this.quid
            });
            fields = _.chain(_this.results).map(function(result) {
              return _.keys(result.attributes);
            }).flatten().uniq().value();
            if (_this["isActions"] !== void 0) {
              _this.fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection", "createdAt", "lastModifiedAt", "Teléfono", "Calleynumero", "Día", "Mes", "Año", "Celular", "Casa", "Direccióndecorreoelectrónico", "NombredeusuariodeFacebook", "Nombredepersonadecontacto", "Parentescoopersonarelacionada", "Completado", "savedBy", "Sexo", "Tieneunnumerocelular", "Tieneunnumerodetelefonoenlacasa", "Tieneunadireccióndecorreoelectrónico", "TieneunnombredeusuariodeFacebook");
            } else {
              _this.fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection");
            }
            return _this.render();
          }
        });
      },
      error: function(data) {
        return alert("Someting wrong");
      }
    });
  };

  ReportView.prototype.initialize = function(options) {
    var key, results, urlParams, value,
      _this = this;
    urlParams = [];
    for (key in options) {
      value = options[key];
      this[key] = value;
      if (key !== "startDate" && key !== "endDate") {
        urlParams.push("" + key + "=" + value + "");
      }
    }
    this.urlParams = urlParams;
    console.log(this.quid);
    results = new Backbone.Collection;
    results.model = Result;
    results.url = "result";
    if (this["isActions"] !== void 0) {
      return _this.getCompletedSurveyUUIDsAndFetch();
    } else {
      return results.fetch({
        success: function(allResults) {
          var fields;
          console.log(allResults.first());
          window.allResults = allResults;
          console.log("trying to get all from");
          console.log(_this.quid);
          _this.results = allResults.where({
            "question": _this.quid
          });
          fields = _.chain(_this.results).map(function(result) {
            return _.keys(result.attributes);
          }).flatten().uniq().value();
          if (_this["isActions"] !== void 0) {
            _this.fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection", "createdAt", "lastModifiedAt", "Teléfono", "Calleynumero", "Día", "Mes", "Año", "Celular", "Casa", "Direccióndecorreoelectrónico", "NombredeusuariodeFacebook", "Nombredepersonadecontacto", "Parentescoopersonarelacionada", "Completado", "savedBy", "Sexo", "Tieneunnumerocelular", "Tieneunnumerodetelefonoenlacasa", "Tieneunadireccióndecorreoelectrónico", "TieneunnombredeusuariodeFacebook");
          } else {
            _this.fields = _(fields).without("_id", "_rev", "test", "user", "question", "collection");
          }
          return _this.render();
        }
      });
    }
  };

  ReportView.prototype.filter = function(event) {
    var id, query, row, _ref1, _results;
    query = this.$el.find("#search").val();
    _ref1 = this.searchRows;
    _results = [];
    for (id in _ref1) {
      row = _ref1[id];
      if (~row.indexOf(query) || query.length < 3) {
        _results.push(this.$el.find(".row-" + id).show());
      } else {
        _results.push(this.$el.find(".row-" + id).hide());
      }
    }
    return _results;
  };

  ReportView.prototype.render = function() {
    var field, headers, html, i, isSurveyExist, result, sPassed, total, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref1, _ref2, _ref3, _ref4;
    this.searchRows = {};
    total = 0;
    headers = [];
    _ref1 = this.results;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      result = _ref1[_i];
      if (this['provider_id'] !== void 0 && result.get('provider_id') !== this['provider_id']) {
        continue;
      }
      total++;
    }
    html = "<div style='font-size: 10pt'><input type='text' id='search' placeholder='filter'>&nbsp;&nbsp;<b>Entradas totales: " + total + "</b></div><br>";
    html += "<div style='overflow:auto;'><table class='tablesorter'>      <thead>        <tr>";
    _ref2 = this.fields;
    for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
      field = _ref2[_j];
      if (this['isActions'] !== void 0) {
        if (field !== "user_name" && field !== "provider_id" && field !== "provider_name") {
          html += "<th>" + field + "</th>";
        }
      } else {
        html += "<th>" + field + "</th>";
      }
      headers[_j] = field;
    }
    if (this["isActions"] !== void 0) {
      html += "<th>Action</th>";
    }
    html += "</tr></thead>    <tbody>";
    _ref3 = this.results;
    for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
      result = _ref3[_k];
      if (this['provider_id'] !== void 0 && result.get('provider_id') !== this['provider_id']) {
        continue;
      }
      html += "<tr class='row-" + result.id + "'>";
      this.searchRows[result.id] = "";
      _ref4 = this.fields;
      for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
        field = _ref4[_l];
        if (this["isActions"] !== void 0 && (field === "user_name" || field === "provider_id" || field === "provider_name")) {
          continue;
        } else {
          html += "<td>" + (result.get(field)) + "</td>";
          this.searchRows[result.id] += result.get(field);
        }
      }
      if (this["isActions"] !== void 0) {
        isSurveyExist = false;
        this.urlParams.push("uuid=" + result.get("uuid"));
        sPassed = "/" + this.urlParams.join("&");
        for (i in this.completedSurveys.rows) {
          if (result.get("uuid") === this.completedSurveys.rows[i].key) {
            isSurveyExist = true;
            break;
          }
        }
        if (isSurveyExist) {
          html += "<td><a href=\"#new/result/Participant Survey-es" + sPassed + "\">View Survey</a></td>";
        } else {
          html += "<td><a href=\"#new/result/Participant Survey-es" + sPassed + "\">New Survey</a></td>";
        }
      }
      html += "</tr>";
    }
    "</tbody></table></div>";
    this.$el.html(html);
    return $("table").each(function() {
      var $table, blob, data, url;
      $table = $(this);
      data = $table.table2CSV({
        delivery: "value",
        header: headers
      });
      blob = new Blob([data], {
        type: "application/octet-binary"
      });
      url = URL.createObjectURL(blob);
      $("<a><font size=\"2px\">Exportar a CSV</font></a>").attr("id", "downloadFile").attr({
        href: url
      }).attr("download", "report.csv").insertBefore($table);
      return $('table tr').each(function(index, row) {
        if (index % 2 === 1) {
          return $(row).addClass("odd");
        }
      });
    });
  };

  return ReportView;

})(Backbone.View);

OldReportView = (function(_super) {
  __extends(OldReportView, _super);

  function OldReportView() {
    this.spreadsheet = __bind(this.spreadsheet, this);
    this.viewQuery = __bind(this.viewQuery, this);
    this.render = __bind(this.render, this);
    this.update = __bind(this.update, this);
    _ref1 = OldReportView.__super__.constructor.apply(this, arguments);
    return _ref1;
  }

  OldReportView.prototype.initialize = function(options) {
    this.quid = options.quid;
    return $("html").append("      <link href='js-libraries/Leaflet/leaflet.css' type='text/css' rel='stylesheet' />      <script type='text/javascript' src='js-libraries/Leaflet/leaflet.js'></script>      <style>        .dissaggregatedResults{          display: none;        }      </style>    ");
  };

  OldReportView.prototype.el = '#content';

  OldReportView.prototype.events = {
    "change #reportOptions": "update",
    "change #summaryField": "summarize",
    "click #toggleDisaggregation": "toggleDisaggregation"
  };

  OldReportView.prototype.update = function() {
    var reportOptions, url;
    reportOptions = {
      startDate: $('#start').val(),
      endDate: $('#end').val(),
      reportType: $('#report-type :selected').text()
    };
    _.each(this.locationTypes, function(location) {
      return reportOptions[location] = $("#" + location + " :selected").text();
    });
    url = "reports/" + _.map(reportOptions, function(value, key) {
      return "" + key + "/" + (escape(value));
    }).join("/");
    return Coconut.router.navigate(url, true);
  };

  OldReportView.prototype.render = function(options) {
    var _this = this;
    this.reportType = options.reportType || "results";
    this.startDate = options.startDate || moment(new Date).subtract('days', 30).format("YYYY-MM-DD");
    this.endDate = options.endDate || moment(new Date).format("YYYY-MM-DD");
    return Coconut.questions.fetch({
      success: function() {}
    }, this.$el.html("        <style>          table.results th.header, table.results td{            font-size:150%;          }        </style>        <table id='reportOptions'></table>        "), $("#reportOptions").append(this.formFilterTemplate({
      id: "question",
      label: "Question",
      form: "              <select id='selected-question'>                " + (Coconut.questions.map(function(question) {
        return "<option>" + (question.label()) + "</option>";
      }).join("")) + "              </select>            "
    })), $("#reportOptions").append(this.formFilterTemplate({
      id: "start",
      label: "Start Date",
      form: "<input id='start' type='date' value='" + this.startDate + "'/>"
    })), $("#reportOptions").append(this.formFilterTemplate({
      id: "end",
      label: "End Date",
      form: "<input id='end' type='date' value='" + this.endDate + "'/>"
    })), $("#reportOptions").append(this.formFilterTemplate({
      id: "report-type",
      label: "Report Type",
      form: "        <select id='report-type'>          " + (_.map(["spreadsheet", "results", "summarytables"], function(type) {
        return "<option " + (type === _this.reportType ? "selected='true'" : void 0) + ">" + type + "</option>";
      }).join("")) + "        </select>        "
    })), this[this.reportType](), $('div[data-role=fieldcontain]').fieldcontain(), $('select').selectmenu(), $('input[type=date]').datebox({
      mode: "calbox"
    }));
  };

  OldReportView.prototype.hierarchyOptions = function(locationType, location) {
    if (locationType === "region") {
      return _.keys(WardHierarchy.hierarchy);
    }
    return _.chain(WardHierarchy.hierarchy).map(function(value, key) {
      if (locationType === "district" && location === key) {
        return _.keys(value);
      }
      return _.map(value, function(value, key) {
        if (locationType === "constituan" && location === key) {
          return _.keys(value);
        }
        return _.map(value, function(value, key) {
          if (locationType === "shehia" && location === key) {
            return value;
          }
        });
      });
    }).flatten().compact().value();
  };

  OldReportView.prototype.mostSpecificLocationSelected = function() {
    var mostSpecificLocationType, mostSpecificLocationValue;
    mostSpecificLocationType = "region";
    mostSpecificLocationValue = "ALL";
    _.each(this.locationTypes, function(locationType) {
      if (this[locationType] !== "ALL") {
        mostSpecificLocationType = locationType;
        return mostSpecificLocationValue = this[locationType];
      }
    });
    return {
      type: mostSpecificLocationType,
      name: mostSpecificLocationValue
    };
  };

  OldReportView.prototype.formFilterTemplate = function(options) {
    return "        <tr>          <td>            <label style='display:inline' for='" + options.id + "'>" + options.label + "</label>           </td>          <td style='width:150%'>            " + options.form + "            </select>          </td>        </tr>    ";
  };

  OldReportView.prototype.viewQuery = function(options) {
    var results;
    results = new ResultCollection();
    return results.fetch({
      question: this.quid,
      isComplete: true,
      include_docs: true,
      success: function() {
        results.fields = {};
        results.each(function(result) {
          return _.each(_.keys(result.attributes), function(key) {
            if (!_.contains(["_id", "_rev", "question"], key)) {
              return results.fields[key] = true;
            }
          });
        });
        results.fields = _.keys(results.fields);
        return options.success(results);
      }
    });
  };

  OldReportView.prototype.results = function() {
    var _this = this;
    this.$el.append("      <table id='results' class='tablesorter'>        <thead>          <tr>          </tr>        </thead>        <tbody>        </tbody>      </table>    ");
    return this.viewQuery({
      success: function(results) {
        var tableData;
        window.theseResults = results;
        tableData = results.map(function(result) {
          return _.map(results.fields, function(field) {
            return result.get(field);
          });
        });
        $("table#results thead tr").append("          " + (_.map(results.fields, function(field) {
          return "<th>" + field + "</th>";
        }).join("")) + "        ");
        $("table#results tbody").append(_.map(tableData, function(row) {
          return "          <tr>            " + (_.map(row, function(element, index) {
            return "              <td>" + element + "</td>            ";
          }).join("")) + "          </tr>        ";
        }).join(""));
        return _.each($('table tr'), function(row, index) {
          if (index % 2 === 1) {
            return $(row).addClass("odd");
          }
        });
      }
    });
  };

  OldReportView.prototype.spreadsheet = function() {
    var _this = this;
    return this.viewQuery({
      success: function(results) {
        var csvData;
        console.log(results);
        csvData = results.map(function(result) {
          return _.map(results.fields, function(field) {
            return result.get(field);
          }).join(",");
        }).join("\n");
        _this.$el.append("          <a id='csv' href='data:text/octet-stream;base64," + (Base64.encode(results.fields.join(",") + "\n" + csvData)) + "' download='" + (_this.startDate + "-" + _this.endDate) + ".csv'>Download spreadsheet</a>        ");
        return $("a#csv").button();
      }
    });
  };

  OldReportView.prototype.summarytables = function() {
    var _this = this;
    return Coconut.resultCollection.fetch({
      includeData: true,
      success: function() {
        var fields;
        fields = _.chain(Coconut.resultCollection.toJSON()).map(function(result) {
          return _.keys(result);
        }).flatten().uniq().sort().value();
        fields = _(fields).without("_id", "_rev");
        _this.$el.append("          <br/>          Choose a field to summarize:<br/>          <select id='summaryField'>            " + (_.map(fields, function(field) {
          return "<option id='" + field + "'>" + field + "</option>";
        }).join("")) + "          </select>        ");
        return $('select').selectmenu();
      }
    });
  };

  OldReportView.prototype.summarize = function() {
    var field,
      _this = this;
    field = $('#summaryField option:selected').text();
    return this.viewQuery({
      success: function(resultCollection) {
        var results;
        results = {};
        resultCollection.each(function(result) {
          return _.each(result.toJSON(), function(value, key) {
            if (key === field) {
              if (results[value] != null) {
                results[value]["sums"] += 1;
                return results[value]["resultIDs"].push(result.get("_id"));
              } else {
                results[value] = {};
                results[value]["sums"] = 1;
                results[value]["resultIDs"] = [];
                return results[value]["resultIDs"].push(result.get("_id"));
              }
            }
          });
        });
        _this.$el.append("          <h2>" + field + "</h2>          <table id='summaryTable' class='tablesorter'>            <thead>              <tr>                <th>Value</th>                <th>Total</th>              </tr>            </thead>            <tbody>              " + (_.map(results, function(aggregates, value) {
          return "                  <tr>                    <td>" + value + "</td>                    <td>                      <button id='toggleDisaggregation'>" + aggregates["sums"] + "</button>                    </td>                    <td class='dissaggregatedResults'>                      " + (_.map(aggregates["resultIDs"], function(resultID) {
            return resultID;
          }).join(", ")) + "                    </td>                  </tr>                  ";
        }).join("")) + "            </tbody>          </table>        ");
        $("button").button();
        $("a").button();
        return _.each($('table tr'), function(row, index) {
          if (index % 2 === 1) {
            return $(row).addClass("odd");
          }
        });
      }
    });
  };

  OldReportView.prototype.toggleDisaggregation = function() {
    return $(".dissaggregatedResults").toggle();
  };

  return OldReportView;

})(Backbone.View);

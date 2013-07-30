// Generated by CoffeeScript 1.6.2
var Case,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Case = (function() {
  function Case(options) {
    this.fetchResults = __bind(this.fetchResults, this);
    this.resultsAsArray = __bind(this.resultsAsArray, this);
    this.daysFromNotificationToCompletion = __bind(this.daysFromNotificationToCompletion, this);
    this.complete = __bind(this.complete, this);
    this.questionStatus = __bind(this.questionStatus, this);
    this.toJSON = __bind(this.toJSON, this);    this.caseID = options != null ? options.caseID : void 0;
    if (options != null ? options.results : void 0) {
      this.loadFromResultDocs(options.results);
    }
  }

  Case.prototype.loadFromResultDocs = function(resultDocs) {
    var userRequiresDeidentification, _ref, _ref1,
      _this = this;

    this.caseResults = resultDocs;
    this.questions = [];
    this["Household Members"] = [];
    userRequiresDeidentification = (((_ref = User.currentUser) != null ? _ref.hasRole("reports") : void 0) || User.currentUser === null) && !((_ref1 = User.currentUser) != null ? _ref1.hasRole("admin") : void 0);
    return _.each(resultDocs, function(resultDoc) {
      var _ref2, _ref3;

      if (resultDoc.toJSON != null) {
        resultDoc = resultDoc.toJSON();
      }
      if (userRequiresDeidentification) {
        _.each(resultDoc, function(value, key) {
          if ((value != null) && _.contains(Coconut.identifyingAttributes, key)) {
            return resultDoc[key] = b64_sha1(value);
          }
        });
      }
      if (resultDoc.question) {
        if ((_ref2 = _this.caseID) == null) {
          _this.caseID = resultDoc["MalariaCaseID"];
        }
        if (_this.caseID !== resultDoc["MalariaCaseID"]) {
          throw "Inconsistent Case ID";
        }
        _this.questions.push(resultDoc.question);
        if (resultDoc.question === "Household Members") {
          return _this["Household Members"].push(resultDoc);
        } else {
          return _this[resultDoc.question] = resultDoc;
        }
      } else {
        if ((_ref3 = _this.caseID) == null) {
          _this.caseID = resultDoc["caseid"];
        }
        if (_this.caseID !== resultDoc["caseid"]) {
          console.log(resultDoc);
          console.log(resultDocs);
          throw "Inconsistent Case ID. Working on " + _this.caseID + " but current doc has " + resultDoc["caseid"];
        }
        _this.questions.push("USSD Notification");
        return _this["USSD Notification"] = resultDoc;
      }
    });
  };

  Case.prototype.fetch = function(options) {
    var _this = this;

    return $.couch.db(Coconut.config.database_name()).view("" + (Coconut.config.design_doc_name()) + "/cases", {
      key: this.caseID,
      include_docs: true,
      success: function(result) {
        _this.loadFromResultDocs(_.pluck(result.rows, "doc"));
        return options != null ? options.success() : void 0;
      },
      error: function() {
        return options != null ? options.error() : void 0;
      }
    });
  };

  Case.prototype.toJSON = function() {
    var returnVal,
      _this = this;

    returnVal = {};
    _.each(this.questions, function(question) {
      return returnVal[question] = _this[question];
    });
    return returnVal;
  };

  Case.prototype.deIdentify = function(result) {};

  Case.prototype.flatten = function(questions) {
    var returnVal,
      _this = this;

    if (questions == null) {
      questions = this.questions;
    }
    returnVal = {};
    _.each(questions, function(question) {
      var type;

      type = question;
      return _.each(_this[question], function(value, field) {
        if (_.isObject(value)) {
          return _.each(value, function(arrayValue, arrayField) {
            return returnVal["" + question + "-" + field + ": " + arrayField] = arrayValue;
          });
        } else {
          return returnVal["" + question + ":" + field] = value;
        }
      });
    });
    return returnVal;
  };

  Case.prototype.LastModifiedAt = function() {
    return _.chain(this.toJSON()).map(function(question) {
      return question.lastModifiedAt;
    }).max(function(lastModifiedAt) {
      return lastModifiedAt != null ? lastModifiedAt.replace(/[- :]/g, "") : void 0;
    }).value();
  };

  Case.prototype.Questions = function() {
    return _.keys(this.toJSON()).join(", ");
  };

  Case.prototype.MalariaCaseID = function() {
    return this.caseID;
  };

  Case.prototype.shehia = function() {
    var _ref, _ref1, _ref2;

    return ((_ref = this.Household) != null ? _ref.Shehia : void 0) || ((_ref1 = this.Facility) != null ? _ref1.Shehia : void 0) || ((_ref2 = this["USSD Notification"]) != null ? _ref2.shehia : void 0);
  };

  Case.prototype.user = function() {
    var userId, _ref, _ref1, _ref2;

    return userId = ((_ref = this.Household) != null ? _ref.user : void 0) || ((_ref1 = this.Facility) != null ? _ref1.user : void 0) || ((_ref2 = this["Case Notification"]) != null ? _ref2.user : void 0);
  };

  Case.prototype.district = function() {
    var district, user;

    if (this.shehia() != null) {
      district = WardHierarchy.district(this.shehia());
    }
    user = this.user();
    if ((user != null) && (district == null)) {
      district = Users.district(user);
    }
    return district;
  };

  Case.prototype.possibleQuestions = function() {
    return ["Case Notification", "Facility", "Household", "Household Members"];
  };

  Case.prototype.questionStatus = function() {
    var result,
      _this = this;

    result = {};
    _.each(this.possibleQuestions(), function(question) {
      var _ref;

      if (question === "Household Members") {
        result["Household Members"] = true;
        return _.each(_this["Household Members"] != null, function(member) {
          if (member.complete === "false") {
            return result["Household Members"] = false;
          }
        });
      } else {
        return result[question] = ((_ref = _this[question]) != null ? _ref.complete : void 0) === "true";
      }
    });
    return result;
  };

  Case.prototype.complete = function() {
    return this.questionStatus()["Household Members"] === true;
  };

  Case.prototype.daysFromNotificationToCompletion = function() {
    var completionTime, startTime;

    startTime = moment(this["Case Notification"].lastModifiedAt);
    completionTime = null;
    _.each(this["Household Members"], function(member) {
      if (moment(member.lastModifiedAt) > completionTime) {
        return completionTime = moment(member.lastModifiedAt);
      }
    });
    return completionTime.diff(startTime, "days");
  };

  Case.prototype.location = function(type) {
    var _ref;

    return WardHierarchy[type]((_ref = this.toJSON()["Case Notification"]) != null ? _ref["FacilityName"] : void 0);
  };

  Case.prototype.withinLocation = function(location) {
    return this.location(location.type) === location.name;
  };

  Case.prototype.hasAdditionalPositiveCasesAtHousehold = function() {
    return _.any(this["Household Members"], function(householdMember) {
      return householdMember.MalariaTestResult === "PF" || householdMember.MalariaTestResult === "Mixed";
    });
  };

  Case.prototype.positiveCasesAtHousehold = function() {
    return _.compact(_.map(this["Household Members"], function(householdMember) {
      if (householdMember.MalariaTestResult === "PF" || householdMember.MalariaTestResult === "Mixed") {
        return householdMember;
      }
    }));
  };

  Case.prototype.positiveCasesIncludingIndex = function() {
    if (this["Facility"]) {
      return this.positiveCasesAtHousehold().concat(_.extend(this["Facility"], this["Household"]));
    } else if (this["USSD Notification"]) {
      return this.positiveCasesAtHousehold().concat(_.extend(this["USSD Notification"], this["Household"], {
        MalariaCaseID: this.MalariaCaseID()
      }));
    }
  };

  Case.prototype.indexCasePatientName = function() {
    var _ref, _ref1;

    if (((_ref = this["Facility"]) != null ? _ref.complete : void 0) === "true") {
      return "" + this["Facility"].FirstName + " " + this["Facility"].LastName;
    }
    if (this["USSD Notification"] != null) {
      return (_ref1 = this["USSD Notification"]) != null ? _ref1.name : void 0;
    }
  };

  Case.prototype.indexCaseDiagnosisDate = function() {
    var _ref;

    if (((_ref = this["Facility"]) != null ? _ref.DateofPositiveResults : void 0) != null) {
      return this["Facility"].DateofPositiveResults;
    } else if (this["USSD Notification"] != null) {
      return this["USSD Notification"].date;
    }
  };

  Case.prototype.householdMembersDiagnosisDate = function() {
    var returnVal;

    returnVal = [];
    return _.each(this["Household Members"] != null, function(member) {
      if (member.MalariaTestResult === "PF" || member.MalariaTestResult === "Mixed") {
        return returnVal.push(member.lastModifiedAt);
      }
    });
  };

  Case.prototype.resultsAsArray = function() {
    var _this = this;

    return _.chain(this.possibleQuestions().map(function(question) {
      return _this[question];
    }).flatten().compact().value());
  };

  Case.prototype.fetchResults = function(options) {
    var count, results,
      _this = this;

    results = _.map(this.resultsAsArray(), function(result) {
      var returnVal;

      returnVal = new Result();
      returnVal.id = result._id;
      return returnVal;
    });
    count = 0;
    _.each(results, function(result) {
      return result.fetch({
        success: function() {
          count += 1;
          if (count >= results.length) {
            return options.success(results);
          }
        }
      });
    });
    return results;
  };

  Case.prototype.updateCaseID = function(newCaseID) {
    return this.fetchResults({
      success: function(results) {
        return _.each(results, function(result) {
          if (result.attributes.MalariaCaseID == null) {
            throw "No MalariaCaseID";
          }
          return result.save({
            MalariaCaseID: newCaseID
          });
        });
      }
    });
  };

  return Case;

})();

/*
//@ sourceMappingURL=Case.map
*/

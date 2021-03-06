// Generated by CoffeeScript 1.6.3
var ResultCollectionWithCollateral, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ResultCollectionWithCollateral = (function(_super) {
  __extends(ResultCollectionWithCollateral, _super);

  function ResultCollectionWithCollateral() {
    _ref = ResultCollectionWithCollateral.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ResultCollectionWithCollateral.prototype.model = Result;

  ResultCollectionWithCollateral.prototype.url = '/result';

  ResultCollectionWithCollateral.prototype.db = {
    view: "resultsByQuestionAndCompleteWithCollateral"
  };

  ResultCollectionWithCollateral.prototype.fetch = function(options) {
    if (options == null) {
      options = {};
    }
    if (options.include_docs == null) {
      options.include_docs = true;
      options.descending = "true";
      if (options.complete === undefined || options.complete === "true") {
        options.startkey = options.question + ":" + "true" + ":z";
        options.endkey = options.question + ":" + "true";
      } else {
        options.startkey = options.question + ":" + "false" + ":z";
        options.endkey = options.question + ":" + "false";
      }
    }
    return ResultCollectionWithCollateral.__super__.fetch.call(this, options);
  };

  ResultCollectionWithCollateral.prototype.notSent = function() {
    return this.filter(function(result) {
      var _ref1;
      return !((_ref1 = result.get("sentTo")) != null ? _ref1.length : void 0);
    });
  };

  ResultCollectionWithCollateral.prototype.filteredByQuestionCategorizedByStatus = function(questionType) {
    var returnObject;
    returnObject = {};
    returnObject.complete = [];
    returnObject.notCompete = [];
    this.each(function(result) {
      if (result.get("question") !== questionType) {
        return;
      }
      switch (result.get("complete")) {
        case true:
          return returnObject.complete.push(result);
        default:
          return returnObject.notComplete.push(result);
      }
    });
    return returnObject;
  };

  ResultCollectionWithCollateral.prototype.filterByQuestionType = function(questionType) {
    return this.filter(function(result) {
      return result.get("question") === questionType;
    });
  };

  ResultCollectionWithCollateral.prototype.partialResults = function(questionType) {
    return this.filter(function(result) {
      return result.get("question") === questionType && !result.complete();
    });
  };

  return ResultCollectionWithCollateral;

})(Backbone.Collection);

/*
//@ sourceMappingURL=ResultCollectionWithCollateral.map
*/

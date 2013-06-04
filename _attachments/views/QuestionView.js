// Generated by CoffeeScript 1.6.2
var QuestionView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.SkipTheseWhen = function(argQuestions, result) {
  var disabledClass, question, questions, _i, _j, _len, _len1, _results;

  questions = [];
  argQuestions = argQuestions.split(/\s*,\s*/);
  for (_i = 0, _len = argQuestions.length; _i < _len; _i++) {
    question = argQuestions[_i];
    questions.push($(".question[data-question-name=" + question + "]"));
  }
  disabledClass = "disabled_skipped";
  _results = [];
  for (_j = 0, _len1 = questions.length; _j < _len1; _j++) {
    question = questions[_j];
    if (result) {
      _results.push(question.addClass(disabledClass));
    } else {
      _results.push(question.removeClass(disabledClass));
    }
  }
  return _results;
};

window.ResultOfQuestion = function(name) {
  var result;

  if ((result = $(".question select[name=" + name + "]")).length !== 0) {
    return result.val();
  }
  if ((result = $(".question input[name=" + name + "]")).length !== 0) {
    if (result.attr("type") === "radio" || result.attr("type") === "checkbox") {
      result = $(".question input[name=" + name + "]:checked");
    }
    return result.val();
  }
  if ((result = $(".question textarea[name=" + name + "]")).length !== 0) {
    return result.val();
  }
};

QuestionView = (function(_super) {
  __extends(QuestionView, _super);

  function QuestionView() {
    this.render = __bind(this.render, this);    _ref = QuestionView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  QuestionView.prototype.initialize = function() {
    var _ref1;

    return (_ref1 = Coconut.resultCollection) != null ? _ref1 : Coconut.resultCollection = new ResultCollection();
  };

  QuestionView.prototype.el = '#content';

  QuestionView.prototype.triggerChangeIn = function(names) {
    var name, _i, _len, _results,
      _this = this;

    _results = [];
    for (_i = 0, _len = names.length; _i < _len; _i++) {
      name = names[_i];
      _results.push($(".question[data-question-name=" + name + "] input, .question[data-question-name=" + name + "] select, .question[data-question-name=" + name + "] textarea").each(function(index, element) {
        var event;

        event = {
          target: element
        };
        return _this.actionOnChange(event);
      }));
    }
    return _results;
  };

  QuestionView.prototype.render = function() {
    var skipperList,
      _this = this;

    this.$el.html("      <div style='position:fixed; right:5px; color:white; background-color: #333; padding:20px; display:none; z-index:10' id='messageText'>        Saving...      </div>      <div id='question-view'>        <form>          " + (this.toHTMLForm(this.model)) + "        </form>      </div>    ");
    this.updateSkipLogic();
    skipperList = [];
    _.each(this.model.get("questions"), function(question) {
      if (question.actionOnChange().match(/skip/i)) {
        skipperList.push(question.safeLabel());
      }
      if (question.get("action_on_questions_loaded") !== "") {
        return CoffeeScript["eval"](question.get("action_on_questions_loaded"));
      }
    });
    console.log(this.result.toJSON());
    js2form($('form').get(0), this.result.toJSON());
    this.triggerChangeIn(skipperList);
    this.$el.find("input[type=text],input[type=number],input[type='autocomplete from previous entries'],input[type='autocomplete from list']").textinput();
    this.$el.find('input[type=radio],input[type=checkbox]').checkboxradio();
    this.$el.find('ul').listview();
    this.$el.find('select').selectmenu();
    this.$el.find('a').button();
    this.$el.find('input[type=date]').datebox({
      mode: "calbox",
      dateFormat: "%d-%m-%Y"
    });
    _.each($("input[type='autocomplete from list'],input[type='autocomplete from previous entries']"), function(element) {
      var source;

      element = $(element);
      if (element.attr("type") === 'autocomplete from list') {
        source = element.attr("data-autocomplete-options").replace(/\n|\t/, "").split(/, */);
      } else {
        source = document.location.pathname.substring(0, document.location.pathname.indexOf("index.html")) + ("_list/values/byValue?key=\"" + (element.attr("name")) + "\"");
      }
      return element.autocomplete({
        source: source,
        target: "#" + (element.attr("id")) + "-suggestions",
        callback: function(event) {
          element.val($(event.currentTarget).text());
          return element.autocomplete('clear');
        }
      });
    });
    $("input[name=complete]").closest("div.question").prepend("        <div style='background-color:yellow' id='validationMessage'></div>      ");
    if (this.readonly) {
      return $('input,textarea').attr("readonly", "true");
    }
  };

  QuestionView.prototype.events = {
    "blur #question-view input": "onChange",
    "change #question-view input": "onChange",
    "change #question-view select": "onChange",
    "change #question-view textarea": "onChange",
    "click #question-view button:contains(+)": "repeat",
    "click #question-view a:contains(Get current location)": "getLocation"
  };

  QuestionView.prototype.onChange = function(event) {
    var eventStamp;

    eventStamp = $(event.target).attr("id") + "-" + event.type;
    if (eventStamp === this.oldStamp) {
      return;
    }
    this.oldStamp = eventStamp;
    this.save();
    this.updateSkipLogic();
    return this.actionOnChange(event);
  };

  QuestionView.prototype.actionOnChange = function(event) {
    var $divQuestion, $target, code, error, message, name, newFunction, nodeName, value;

    nodeName = $(event.target).get(0).nodeName;
    $target = nodeName === "INPUT" || nodeName === "SELECT" || nodeName === "TEXTAREA" ? $(event.target) : $(event.target).parent().parent().parent().find("input,textarea,select");
    name = $target.attr("name");
    $divQuestion = $(".question [data-question-name=" + name + "]");
    code = $divQuestion.attr("data-action_on_change");
    value = ResultOfQuestion(name);
    if (code === "" || (code == null)) {
      return;
    }
    code = "(value) -> " + code;
    try {
      newFunction = CoffeeScript["eval"].apply(this, [code]);
      return newFunction(value);
    } catch (_error) {
      error = _error;
      name = (/function (.{1,})\(/.exec(error.constructor.toString())[1]);
      message = error.message;
      return alert("Action on change error in question " + ($divQuestion.attr('data-question-id') || $divQuestion.attr("id")) + "\n\n" + name + "\n\n" + message);
    }
  };

  QuestionView.prototype.updateSkipLogic = function() {
    return _($(".question")).each(function(question) {
      var error, id, message, name, result, skipLogicCode;

      question = $(question);
      skipLogicCode = question.attr("data-skip_logic");
      if (skipLogicCode === "" || (skipLogicCode == null)) {
        return;
      }
      try {
        result = CoffeeScript["eval"].apply(this, [skipLogicCode]);
      } catch (_error) {
        error = _error;
        name = (/function (.{1,})\(/.exec(error.constructor.toString())[1]);
        message = error.message;
        alert("Skip logic error in question " + (question.attr('data-question-id')) + "\n\n" + name + "\n\n" + message);
      }
      id = question.attr('data-question-id');
      if (result) {
        return question.addClass("disabled_skipped");
      } else {
        return question.removeClass("disabled_skipped");
      }
    });
  };

  QuestionView.prototype.getLocation = function(event) {
    var question_id,
      _this = this;

    question_id = $(event.target).closest("[data-question-id]").attr("data-question-id");
    $("#" + question_id + "-description").val("Retrieving position, please wait.");
    return navigator.geolocation.getCurrentPosition(function(geoposition) {
      _.each(geoposition.coords, function(value, key) {
        return $("#" + question_id + "-" + key).val(value);
      });
      $("#" + question_id + "-timestamp").val(moment(geoposition.timestamp).format(Coconut.config.get("date_format")));
      $("#" + question_id + "-description").val("Success");
      _this.save();
      return $.getJSON("http://api.geonames.org/findNearbyPlaceNameJSON?lat=" + geoposition.coords.latitude + "&lng=" + geoposition.coords.longitude + "&username=mikeymckay&callback=?", null, function(result) {
        $("#" + question_id + "-description").val(parseFloat(result.geonames[0].distance).toFixed(1) + " km from center of " + result.geonames[0].name);
        return _this.save();
      });
    }, function(error) {
      return $("#" + question_id + "-description").val("Error: " + error);
    }, {
      frequency: 1000,
      enableHighAccuracy: true,
      timeout: 30000,
      maximumAge: 0
    });
  };

  QuestionView.prototype.validate = function(result) {
    var _ref1,
      _this = this;

    $("#validationMessage").html("");
    _.each(result, function(value, key) {
      return $("#validationMessage").append(_this.validateItem(value, key));
    });
    _.chain($("input[type=radio]")).map(function(element) {
      return $(element).attr("name");
    }).uniq().map(function(radioName) {
      var labelID, labelText, question, required, _ref1;

      question = $("input[name=" + radioName + "]").closest("div.question");
      required = question.attr("data-required") === "true";
      if (required && !$("input[name=" + radioName + "]").is(":checked")) {
        labelID = question.attr("data-question-id");
        labelText = (_ref1 = $("label[for=" + labelID + "]")) != null ? _ref1.text() : void 0;
        return $("#validationMessage").append("'" + labelText + "' is required<br/>");
      }
    });
    if ($("#validationMessage").html() !== "") {
      if ((_ref1 = $("input[name=complete]")) != null) {
        _ref1.prop("checked", false);
      }
      return false;
    } else {
      return true;
    }
  };

  QuestionView.prototype.validateItem = function(value, question_id) {
    var labelText, question, required, result, validation, validationFunction, _ref1;

    result = [];
    question = $("[name=" + question_id + "]");
    labelText = (_ref1 = $("label[for=" + (question.attr("id")) + "]")) != null ? _ref1.text() : void 0;
    required = question.closest("div.question").attr("data-required") === "true";
    validation = unescape(question.closest("div.question").attr("data-validation"));
    if (required && (value == null)) {
      result.push("'" + labelText + "' is required (NA or 9999 may be used if information not available)");
    }
    if (validation !== "undefined" && validation !== null) {
      validationFunction = CoffeeScript["eval"]("(value) -> " + validation, {
        bare: true
      });
      result.push(validationFunction(value));
    }
    result = _.compact(result);
    if (result.length > 0) {
      return result.join("<br/>") + "<br/>";
    } else {
      return "";
    }
  };

  QuestionView.prototype.save = _.throttle(function() {
    var currentData;

    currentData = $('form').toObject({
      skipEmpty: false
    });
    if (currentData.complete && !this.validate(currentData)) {
      return;
    }
    this.result.save(_.extend(currentData, {
      lastModifiedAt: moment(new Date()).format(Coconut.config.get("date_format")),
      savedBy: $.cookie('current_user')
    }), {
      success: function() {
        return $("#messageText").slideDown().fadeOut();
      }
    });
    this.key = "MalariaCaseID";
    return Coconut.menuView.update();
  }, 1000);

  QuestionView.prototype.currentKeyExistsInResultsFor = function(question) {
    var _this = this;

    return Coconut.resultCollection.any(function(result) {
      return _this.result.get(_this.key) === result.get(_this.key) && result.get('question') === question;
    });
  };

  QuestionView.prototype.repeat = function(event) {
    var button, inputElement, name, newIndex, newQuestion, questionID, re, _i, _len, _ref1;

    button = $(event.target);
    newQuestion = button.prev(".question").clone();
    questionID = newQuestion.attr("data-group-id");
    if (questionID == null) {
      questionID = "";
    }
    _ref1 = newQuestion.find("input");
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      inputElement = _ref1[_i];
      inputElement = $(inputElement);
      name = inputElement.attr("name");
      re = new RegExp("" + questionID + "\\[(\\d)\\]");
      newIndex = parseInt(_.last(name.match(re))) + 1;
      inputElement.attr("name", name.replace(re, "" + questionID + "[" + newIndex + "]"));
    }
    button.after(newQuestion.add(button.clone()));
    return button.remove();
  };

  QuestionView.prototype.toHTMLForm = function(questions, groupId) {
    var _this = this;

    if (questions == null) {
      questions = this.model;
    }
    if (questions.length == null) {
      questions = [questions];
    }
    return _.map(questions, function(question) {
      var html, index, name, newGroupId, option, options, question_id, repeatable;

      if (question.repeatable() === "true") {
        repeatable = "<button>+</button>";
      } else {
        repeatable = "";
      }
      if ((question.type() != null) && (question.label() != null) && question.label() !== "") {
        name = question.safeLabel();
        question_id = question.get("id");
        if (question.repeatable() === "true") {
          name = name + "[0]";
          question_id = question.get("id") + "-0";
        }
        if (groupId != null) {
          name = "group." + groupId + "." + name;
        }
        return "          <div             " + (question.validation() ? question.validation() ? "data-validation = '" + (escape(question.validation())) + "'" : void 0 : "") + "             data-required='" + (question.required()) + "'            class='question " + ((typeof question.type === "function" ? question.type() : void 0) || '') + "'            data-question-name='" + name + "'            data-question-id='" + question_id + "'            data-skip_logic='" + (_.escape(question.skipLogic())) + "'            data-action_on_change='" + (_.escape(question.actionOnChange())) + "'          >" + (!question.type().match(/hidden/) ? "<label type='" + (question.type()) + "' for='" + question_id + "'>" + (question.label()) + " <span></span></label>" : void 0) + "          " + ((function() {
          var _i, _len, _ref1;

          switch (question.type()) {
            case "textarea":
              return "<input name='" + name + "' type='text' id='" + question_id + "' value='" + (question.value()) + "'></input>";
            case "select":
              if (this.readonly) {
                return question.value();
              } else {
                html = "<select>";
                _ref1 = question.get("select-options").split(/, */);
                for (index = _i = 0, _len = _ref1.length; _i < _len; index = ++_i) {
                  option = _ref1[index];
                  html += "<option name='" + name + "' id='" + question_id + "-" + index + "' value='" + option + "'>" + option + "</option>";
                }
                return html += "</select>";
              }
              break;
            case "radio":
              if (this.readonly) {
                return "<input name='" + name + "' type='text' id='" + question_id + "' value='" + (question.value()) + "'></input>";
              } else {
                options = question.get("radio-options");
                return _.map(options.split(/, */), function(option, index) {
                  return "                      <label for='" + question_id + "-" + index + "'>" + option + "</label>                      <input type='radio' name='" + name + "' id='" + question_id + "-" + index + "' value='" + option + "'/>                    ";
                }).join("");
              }
              break;
            case "checkbox":
              if (this.readonly) {
                return "<input name='" + name + "' type='text' id='" + question_id + "' value='" + (question.value()) + "'></input>";
              } else {
                return "<input style='display:none' name='" + name + "' id='" + question_id + "' type='checkbox' value='true'></input>";
              }
              break;
            case "autocomplete from list":
            case "autocomplete from previous entries":
              return "                  <!-- autocomplete='off' disables browser completion -->                  <input autocomplete='off' name='" + name + "' id='" + question_id + "' type='" + (question.type()) + "' value='" + (question.value()) + "' data-autocomplete-options='" + (question.get("autocomplete-options")) + "'></input>                  <ul id='" + question_id + "-suggestions' data-role='listview' data-inset='true'/>                ";
            case "location":
              return "                  <a data-question-id='" + question_id + "'>Get current location</a>                  <label for='" + question_id + "-description'>Location Description</label>                  <input type='text' name='" + name + "-description' id='" + question_id + "-description'></input>                  " + (_.map(["latitude", "longitude"], function(field) {
                return "<label for='" + question_id + "-" + field + "'>" + field + "</label><input readonly='readonly' type='number' name='" + name + "-" + field + "' id='" + question_id + "-" + field + "'></input>";
              }).join("")) + "                  " + (_.map(["altitude", "accuracy", "altitudeAccuracy", "heading", "timestamp"], function(field) {
                return "<input type='hidden' name='" + name + "-" + field + "' id='" + question_id + "-" + field + "'></input>";
              }).join("")) + "                ";
            case "image":
              return "<img style='" + (question.get("image-style")) + "' src='" + (question.get("image-path")) + "'/>";
            case "label":
              return "";
            default:
              return "<input name='" + name + "' id='" + question_id + "' type='" + (question.type()) + "' value='" + (question.value()) + "'></input>";
          }
        }).call(_this)) + "          </div>          " + repeatable + "        ";
      } else {
        newGroupId = question_id;
        if (question.repeatable()) {
          newGroupId = newGroupId + "[0]";
        }
        return ("<div data-group-id='" + question_id + "' class='question group'>") + _this.toHTMLForm(question.questions(), newGroupId) + "</div>" + repeatable;
      }
    }).join("");
  };

  return QuestionView;

})(Backbone.View);

/*
//@ sourceMappingURL=QuestionView.map
*/

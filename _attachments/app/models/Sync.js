// Generated by CoffeeScript 1.6.2
var Sync, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Sync = (function(_super) {
  __extends(Sync, _super);

  function Sync() {
    this.replicateApplicationDocs = __bind(this.replicateApplicationDocs, this);
    this.getFromCloud = __bind(this.getFromCloud, this);
    this.log = __bind(this.log, this);
    this.last_get_time = __bind(this.last_get_time, this);
    this.was_last_get_successful = __bind(this.was_last_get_successful, this);
    this.last_send_time = __bind(this.last_send_time, this);
    this.was_last_send_successful = __bind(this.was_last_send_successful, this);
    this.last_send = __bind(this.last_send, this);    _ref = Sync.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Sync.prototype.initialize = function() {
    return this.set({
      _id: "SyncLog"
    });
  };

  Sync.prototype.url = "/sync";

  Sync.prototype.target = function() {
    return Coconut.config.cloud_url();
  };

  Sync.prototype.last_send = function() {
    return this.get("last_send_result");
  };

  Sync.prototype.was_last_send_successful = function() {
    var last_send_data;

    if (this.get("last_send_error") === true) {
      return false;
    }
    last_send_data = this.last_send();
    if (last_send_data == null) {
      return false;
    }
    if ((last_send_data.no_changes != null) && last_send_data.no_changes === true) {
      return true;
    }
    return (last_send_data.docs_read === last_send_data.docs_written) && last_send_data.doc_write_failures === 0;
  };

  Sync.prototype.last_send_time = function() {
    var result;

    result = this.get("last_send_time");
    if (result) {
      return moment(this.get("last_send_time")).fromNow();
    } else {
      return "never";
    }
  };

  Sync.prototype.was_last_get_successful = function() {
    return this.get("last_get_success");
  };

  Sync.prototype.last_get_time = function() {
    var result;

    result = this.get("last_get_time");
    if (result) {
      return moment(this.get("last_get_time")).fromNow();
    } else {
      return "never";
    }
  };

  Sync.prototype.sendToCloud = function(options) {
    var _this = this;

    return this.fetch({
      error: function(error) {
        return _this.log("Unable to fetch Sync doc: " + (error.toJSON()));
      },
      success: function() {
        _this.log("Checking for internet. (Is " + (Coconut.config.cloud_url()) + " is reachable?) Please wait.");
        return $.ajax({
          dataType: "jsonp",
          url: Coconut.config.cloud_url(),
          error: function(error) {
            _this.log("ERROR! " + (Coconut.config.cloud_url()) + " is not reachable. Either the internet is not working or the site is down: " + (error.toJSON()));
            options.error();
            return _this.save({
              last_send_error: true
            });
          },
          success: function() {
            _this.log("" + (Coconut.config.cloud_url()) + " is reachable, so internet is available.");
            _this.log("Creating list of all results on the tablet. Please wait.");
            return $.couch.db(Coconut.config.database_name()).view("" + (Coconut.config.design_doc_name()) + "/results", {
              include_docs: false,
              error: function(result) {
                _this.log("Could not retrieve list of results: " + (error.toJSON()));
                options.error();
                return _this.save({
                  last_send_error: true
                });
              },
              success: function(result) {
                var resultIDs;

                _this.log("Synchronizing " + result.rows.length + " results. Please wait.");
                resultIDs = _.pluck(result.rows, "id");
                return $.couch.db(Coconut.config.database_name()).saveDoc({
                  collection: "log",
                  action: "sendToCloud",
                  user: User.currentUser.id,
                  time: moment().format(Coconut.config.get("date_format"))
                }, {
                  error: function(error) {
                    return _this.log("Could not create log file: " + (error.toJSON()));
                  },
                  success: function() {
                    return $.couch.replicate(Coconut.config.database_name(), Coconut.config.cloud_url_with_credentials(), {
                      success: function(result) {
                        _this.log("Send data finished: created, updated or deleted " + result.docs_written + " results on the server.");
                        _this.save({
                          last_send_result: result,
                          last_send_error: false,
                          last_send_time: new Date().getTime()
                        });
                        return _this.sendLogMessagesToCloud({
                          success: function() {
                            return options.success();
                          },
                          error: function(error) {
                            this.save({
                              last_send_error: true
                            });
                            return options.error(error);
                          }
                        });
                      }
                    }, {
                      doc_ids: resultIDs
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
  };

  Sync.prototype.log = function(message) {
    return Coconut.debug(message);
  };

  Sync.prototype.sendLogMessagesToCloud = function(options) {
    var _this = this;

    return this.fetch({
      error: function(error) {
        return _this.log("Unable to fetch Sync doc: " + (error.toJSON()));
      },
      success: function() {
        return $.couch.db(Coconut.config.database_name()).view("" + (Coconut.config.design_doc_name()) + "/byCollection", {
          key: "log",
          include_docs: false,
          error: function(error) {
            _this.log("Could not retrieve list of log entries: " + (error.toJSON()));
            options.error(error);
            return _this.save({
              last_send_error: true
            });
          },
          success: function(result) {
            var logIDs;

            _this.log("Sending " + result.rows.length + " log entries. Please wait.");
            logIDs = _.pluck(result.rows, "id");
            return $.couch.replicate(Coconut.config.database_name(), Coconut.config.cloud_url_with_credentials(), {
              success: function(result) {
                _this.save({
                  last_send_result: result,
                  last_send_error: false,
                  last_send_time: new Date().getTime()
                });
                _this.log("Successfully sent " + result.docs_written + " log messages to the server.");
                return options.success();
              },
              error: function(error) {
                this.log("Could not send log messages to the server: " + (error.toJSON()));
                this.save({
                  last_send_error: true
                });
                return typeof options.error === "function" ? options.error(error) : void 0;
              }
            }, {
              doc_ids: logIDs
            });
          }
        });
      }
    });
  };

  Sync.prototype.getFromCloud = function(options) {
    var _this = this;

    return this.fetch({
      error: function(error) {
        return _this.log("Unable to fetch Sync doc: " + (error.toJSON()));
      },
      success: function() {
        _this.log("Checking that " + (Coconut.config.cloud_url()) + " is reachable. Please wait.");
        return $.ajax({
          dataType: "jsonp",
          url: Coconut.config.cloud_url(),
          error: function(error) {
            _this.log("ERROR! " + (Coconut.config.cloud_url()) + " is not reachable. Either the internet is not working or the site is down: " + (error.toJSON()));
            return typeof options.error === "function" ? options.error(error) : void 0;
          },
          success: function() {
            _this.log("" + (Coconut.config.cloud_url()) + " is reachable, so internet is available.");
            return _this.fetch({
              success: function() {
                return _this.getNewNotifications({
                  success: function() {
                    return $.couch.login({
                      name: Coconut.config.get("local_couchdb_admin_username"),
                      password: Coconut.config.get("local_couchdb_admin_password"),
                      error: function(error) {
                        _this.log("ERROR logging in as local admin: " + (error.toJSON()));
                        return options != null ? typeof options.error === "function" ? options.error() : void 0 : void 0;
                      },
                      success: function() {
                        _this.log("Updating users, forms and the design document. Please wait.");
                        return _this.replicateApplicationDocs({
                          error: function(error) {
                            $.couch.logout();
                            _this.log("ERROR updating application: " + (error.toJSON()));
                            _this.save({
                              last_get_success: false
                            });
                            return options != null ? typeof options.error === "function" ? options.error(error) : void 0 : void 0;
                          },
                          success: function() {
                            $.couch.logout();
                            return $.couch.db(Coconut.config.database_name()).saveDoc({
                              collection: "log",
                              action: "getFromCloud",
                              user: User.currentUser.id,
                              time: moment().format(Coconut.config.get("date_format"))
                            }, {
                              error: function(error) {
                                return _this.log("Could not create log file " + (error.toJSON()));
                              },
                              success: function() {
                                _this.log("Sending log messages to cloud.");
                                return _this.sendLogMessagesToCloud({
                                  success: function() {
                                    _this.log("Finished, refreshing app in 5 seconds...");
                                    return _this.fetch({
                                      error: function(error) {
                                        return _this.log("Unable to fetch Sync doc: " + (error.toJSON()));
                                      },
                                      success: function() {
                                        _this.save({
                                          last_get_success: true,
                                          last_get_time: new Date().getTime()
                                        });
                                        if (options != null) {
                                          if (typeof options.success === "function") {
                                            options.success();
                                          }
                                        }
                                        return _.delay(function() {
                                          return document.location.reload();
                                        }, 5000);
                                      }
                                    });
                                  }
                                });
                              }
                            });
                          }
                        });
                      }
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
  };

  Sync.prototype.getNewNotifications = function(options) {
    var _this = this;

    this.log("Looking for most recent Case Notification. Please wait.");
    return $.couch.db(Coconut.config.database_name()).view("" + (Coconut.config.design_doc_name()) + "/rawNotificationsConvertedToCaseNotifications", {
      descending: true,
      include_docs: true,
      limit: 1,
      success: function(result) {
        var district, mostRecentNotification, shehias, url, _ref1, _ref2;

        mostRecentNotification = (_ref1 = result.rows) != null ? (_ref2 = _ref1[0]) != null ? _ref2.doc.date : void 0 : void 0;
        url = "" + (Coconut.config.cloud_url_with_credentials()) + "/_design/" + (Coconut.config.design_doc_name()) + "/_view/notifications?&ascending=true&include_docs=true";
        if (mostRecentNotification != null) {
          url += "&startkey=\"" + mostRecentNotification + "\"&skip=1";
        }
        district = User.currentUser.get("district");
        shehias = WardHierarchy.allWards({
          district: district
        });
        if (!district) {
          shehias = [];
        }
        _this.log("Looking for USSD notifications " + (mostRecentNotification != null ? "after " + mostRecentNotification : "") + ". Please wait.");
        return $.ajax({
          url: url,
          dataType: "jsonp",
          success: function(result) {
            _this.log("Found " + result.rows.length + " USSD notifications. Filtering for USSD notifications for district:  " + district + ". Please wait.");
            _.each(result.rows, function(row) {
              var notification;

              notification = row.doc;
              if (_.include(shehias, notification.shehia)) {
                result = new Result({
                  question: "Case Notification",
                  MalariaCaseID: notification.caseid,
                  FacilityName: notification.hf,
                  Shehia: notification.shehia,
                  Name: notification.name
                });
                result.save();
                notification.hasCaseNotification = true;
                $.couch.db(Coconut.config.database_name()).saveDoc(notification);
                return _this.log("Created new case notification " + (result.get("MalariaCaseID")) + " for patient " + (result.get("Name")) + " at " + (result.get("FacilityName")));
              }
            });
            return typeof options.success === "function" ? options.success() : void 0;
          },
          error: function(result) {
            return _this.log("ERROR, could not download USSD notifications.");
          }
        });
      }
    });
  };

  Sync.prototype.replicate = function(options) {
    return $.couch.login({
      name: Coconut.config.get("local_couchdb_admin_username"),
      password: Coconut.config.get("local_couchdb_admin_password"),
      success: function() {
        return $.couch.replicate(Coconut.config.cloud_url_with_credentials(), Coconut.config.database_name(), {
          success: function() {
            return options.success();
          },
          error: function() {
            return options.error();
          }
        }, options.replicationArguments);
      },
      error: function() {
        return console.log("Unable to login as local admin for replicating the design document (main application)");
      }
    });
  };

  Sync.prototype.replicateApplicationDocs = function(options) {
    var _this = this;

    return $.ajax({
      dataType: "jsonp",
      url: "" + (Coconut.config.cloud_url_with_credentials()) + "/_design/" + (Coconut.config.design_doc_name()) + "/docIDsForUpdating",
      include_docs: false,
      error: function(error) {
        return typeof options.error === "function" ? options.error(error) : void 0;
      },
      success: function(result) {
        var doc_ids;

        doc_ids = _.pluck(result.rows, "id");
        _this.log("Updating " + doc_ids.length + " docs (users, forms and the design document). Please wait.");
        return _this.replicate(_.extend(options, {
          replicationArguments: {
            doc_ids: doc_ids
          }
        }));
      }
    });
  };

  return Sync;

})(Backbone.Model);

/*
//@ sourceMappingURL=Sync.map
*/
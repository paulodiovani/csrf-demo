(function() {
  var Router, controller, url,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  url = require("url");

  controller = require("./controller");

  Router = (function() {
    function Router() {
      this.process = __bind(this.process, this);
    }

    Router.prototype._routes = [];

    Router.prototype.add = function(path, action) {
      this._routes.push({
        path: path,
        action: action
      });
    };

    Router.prototype.process = function(req, res) {
      var action, u;
      u = url.parse(req.url);
      action = this._getAction(u.pathname);
      if (action != null) {
        controller[action](req, res);
        console.log("[Requested: " + u.path + "]", "[Logged user: " + (controller.getLoggedUser()) + "]", "[200]");
      } else {
        controller.error(req, res, 404);
        console.warn("[Requested: " + u.path + "]", "[Logged user: " + (controller.getLoggedUser()) + "]", "[404]");
      }
    };

    Router.prototype._getAction = function(path) {
      var r, _i, _len, _ref;
      _ref = this._routes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        r = _ref[_i];
        if (r.path === path) {
          return r.action;
        }
      }
      return null;
    };

    return Router;

  })();

  module.exports = new Router();

}).call(this);

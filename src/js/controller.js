(function() {
  var Controller, fs, jade,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  fs = require("fs");

  jade = require("jade");

  Controller = (function() {
    function Controller() {
      this.login = __bind(this.login, this);
    }

    Controller.prototype.req = null;

    Controller.prototype.res = null;

    Controller.prototype.login = function(req, res) {
      this.req = req;
      this.res = res;
      return this._render("login");
    };

    Controller.prototype.error = function(req, res, code) {
      var view;
      this.req = req;
      this.res = res;
      view = "error" + code;
      return this._render(view, null, code);
    };

    Controller.prototype._render = function(view, data, code) {
      var tpl, viewFn, viewPath;
      if (data == null) {
        data = null;
      }
      if (code == null) {
        code = 200;
      }
      viewPath = "views/" + view + ".jade";
      tpl = fs.readFileSync(viewPath);
      viewFn = jade.compile(tpl.toString(), {
        filename: viewPath
      });
      this.res.writeHead(code, {
        "Content-Type": "text/html"
      });
      return this.res.write(viewFn());
    };

    return Controller;

  })();

  module.exports = new Controller();

}).call(this);

(function() {
  var Controller, config, fs, jade, qs,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  qs = require("querystring");

  fs = require("fs");

  jade = require("jade");

  config = require("../../config.json");

  Controller = (function() {
    function Controller() {
      this.login = __bind(this.login, this);
    }

    Controller.prototype.req = null;

    Controller.prototype.res = null;

    Controller.prototype.login = function(req, res) {
      var data;
      this.req = req;
      this.res = res;
      data = {
        usename: null
      };
      return this._parsePost((function(_this) {
        return function(post) {
          var u, _i, _len, _ref;
          if (post) {
            _ref = config.users;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              u = _ref[_i];
              console.log(u, post);
              if (post.username === u.username && post.password === u.password) {
                data.username = post.username;
                break;
              }
            }
            if (data.logged == null) {
              data.errormessage = "Usuário e senha incorretos.";
            }
          }
          return _this._render("login", data);
        };
      })(this));
    };

    Controller.prototype.error = function(req, res, code) {
      var view;
      this.req = req;
      this.res = res;
      view = "error" + code;
      return this._render(view, null, code);
    };

    Controller.prototype._parsePost = function(callback) {
      var body;
      body = "";
      this.req.on("data", function(chunk) {
        return body += chunk.toString();
      });
      return this.req.on("end", (function(_this) {
        return function() {
          var post;
          if (body !== "") {
            post = qs.parse(body);
          }
          return callback.call(_this, post);
        };
      })(this));
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
      this.res.write(viewFn(data));
      return this.res.end();
    };

    return Controller;

  })();

  module.exports = new Controller();

}).call(this);

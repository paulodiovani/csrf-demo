(function() {
  var Controller, config, crypto, fs, jade, qs, url,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  url = require("url");

  qs = require("querystring");

  fs = require("fs");

  jade = require("jade");

  crypto = require("crypto");

  config = require("../../config.json");

  Controller = (function() {
    function Controller() {
      this.logout = __bind(this.logout, this);
      this.login = __bind(this.login, this);
    }

    Controller.prototype.req = null;

    Controller.prototype.res = null;

    Controller.prototype.login = function(req, res) {
      var data;
      this.req = req;
      this.res = res;
      data = {
        username: this.getLoggedUser(),
        pathname: this._urlPathname()
      };
      this._parsePost((function(_this) {
        return function(post) {
          var hash, head, md5, md5pass;
          if (post != null) {
            md5 = crypto.createHash("md5");
            md5.update(post.password);
            md5pass = md5.digest("hex");
            if (_this._loginValid(post.username, md5pass)) {
              data.username = post.username;
              hash = _this._getCookieHash(post.username, md5pass);
              head = [
                200, {
                  "Set-Cookie": "login=" + hash,
                  "Content-Type": "text/html"
                }
              ];
            } else {
              data.errormessage = "Usuário e senha incorretos.";
              head = null;
            }
          }
          return _this._render("login", data, head);
        };
      })(this));
    };

    Controller.prototype.logout = function(req, res) {
      this.req = req;
      this.res = res;
      this.res.writeHead(302, {
        "Set-Cookie": "login=",
        "Location": "/"
      });
      this.res.end();
    };

    Controller.prototype.getLoggedUser = function() {
      var cookies, hash, password, u, username, _i, _len, _ref;
      cookies = this._parseCookie();
      if (cookies.login) {
        _ref = config.users;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          u = _ref[_i];
          username = u[0], password = u[1];
          hash = this._getCookieHash(username, password);
          if (hash === cookies.login) {
            return username;
          }
        }
      }
      return null;
    };

    Controller.prototype.error = function(req, res, code) {
      var view;
      this.req = req;
      this.res = res;
      view = "error" + code;
      this._render(view, null, [
        code, {
          "Content-Type": "text/html"
        }
      ]);
    };

    Controller.prototype._urlPathname = function() {
      var u;
      u = url.parse(this.req.url);
      return u.pathname;
    };

    Controller.prototype._loginValid = function(user, md5pass) {
      var password, u, username, _i, _len, _ref;
      _ref = config.users;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        u = _ref[_i];
        username = u[0], password = u[1];
        if (user === username && md5pass === password) {
          return true;
        }
      }
      return false;
    };

    Controller.prototype._getCookieHash = function(user, md5pass) {
      var hash, sha1;
      sha1 = crypto.createHash("sha1");
      sha1.update(user);
      sha1.update(md5pass);
      hash = sha1.digest("hex");
      return hash.slice(0, 7);
    };

    Controller.prototype._parsePost = function(callback) {
      var body;
      body = "";
      this.req.on("data", function(chunk) {
        return body += chunk.toString();
      });
      this.req.on("end", (function(_this) {
        return function() {
          var post;
          if (body !== "") {
            post = qs.parse(body);
          }
          return callback.call(_this, post);
        };
      })(this));
    };

    Controller.prototype._parseCookie = function() {
      var cookie, key, list, rc, val, _i, _len, _ref, _ref1;
      list = {};
      rc = this.req.headers.cookie;
      if (rc != null) {
        _ref = rc.split(";");
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cookie = _ref[_i];
          _ref1 = cookie.split("="), key = _ref1[0], val = _ref1[1];
          list[key] = val;
        }
      }
      return list;
    };

    Controller.prototype._render = function(view, data, head) {
      var code, obj, tpl, viewFn, viewPath, _ref;
      if (data == null) {
        data = null;
      }
      if (head == null) {
        head = null;
      }
      viewPath = "views/" + view + ".jade";
      tpl = fs.readFileSync(viewPath);
      viewFn = jade.compile(tpl.toString(), {
        filename: viewPath
      });
      _ref = head != null ? head : [
        200, {
          "Content-Type": "text/html"
        }
      ], code = _ref[0], obj = _ref[1];
      this.res.writeHead(code, obj);
      this.res.write(viewFn(data));
      this.res.end();
    };

    return Controller;

  })();

  module.exports = new Controller();

}).call(this);

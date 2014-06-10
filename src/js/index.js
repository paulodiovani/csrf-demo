(function() {
  var fs, http, jade, port, server, url;

  fs = require("fs");

  http = require("http");

  url = require("url");

  jade = require("jade");

  port = process.argv[2] || 8082;

  server = http.createServer();

  server.listen(port);

  console.log("Servidor rodando na porta " + port);

  server.on("request", function(req, res) {
    var tpl, u, view, viewFn;
    u = url.parse(req.url, true);
    console.log("Requested " + u.path);
    switch (u.pathname) {
      case "/":
      case "/login":
        view = "views/login.jade";
        tpl = fs.readFileSync(view);
        viewFn = jade.compile(tpl.toString(), {
          filename: view
        });
        res.writeHead(200, {
          "Content-Type": "text/html"
        });
        return res.end(viewFn());
      default:
        res.writeHead(404, {
          "Content-Type": "text/html"
        });
        return res.end("Página não encontrada");
    }
  });

}).call(this);

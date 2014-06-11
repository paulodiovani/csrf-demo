(function() {
  var http, port, router, server;

  http = require("http");

  router = require("./router");

  port = process.argv[2] || 8082;

  server = http.createServer();

  server.listen(port);

  console.log("Servidor rodando na porta " + port);

  router.add("/", "login");

  router.add("/login", "login");

  server.on("request", router.process);

}).call(this);

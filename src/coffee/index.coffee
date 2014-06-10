# Dependências requeridas
fs   = require("fs")
http = require("http")
url  = require("url")
jade = require("jade")

# Obtém a porta à escutar, ou `8082` por padrão
port = process.argv[2] || 8082

# Inicia um servidor HTTP
server = http.createServer()
server.listen port
console.log "Servidor rodando na porta #{port}"

# Escuta as requisições
server.on "request", (req, res) ->
  u = url.parse(req.url, true)

  # Vamos fazer um log no console de todas as requisições
  console.log "Requested #{u.path}"

  # Analiza o `pathname` solicitado na url
  # para então processar a view correta
  switch u.pathname
    
    # Solicitada a página de login
    when "/", "/login"
      # Lê e compila o template Jade
      view   = "views/login.jade"
      tpl    = fs.readFileSync view
      viewFn = jade.compile tpl.toString(), {filename: view}
      
      # Então renderiza o mesmo
      res.writeHead 200, {"Content-Type": "text/html"}
      res.end viewFn()

    # Caso seja uma página não esperada, envia mensagem de erro
    else
      res.writeHead 404, {"Content-Type": "text/html"}
      res.end "Página não encontrada"
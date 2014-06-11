# O Router é responsável por
# interpretar as requisições e
# executar o método correto do
# controller

# Dependências requeridas
url = require("url")
controller = require("./controller")

# Inicio da classe
class Router
  # Rotas definidas para
  # os métodos do controller
  _routes: []

  # Adiciona/mapeia uma roda
  add: (path, action) ->
    @_routes.push
      path: path
      action: action

  # Processa uma requisição,
  # executando um método do controller
  process: (req, res) =>
    u = url.parse(req.url, true)

    # Faz um log no console de todas as requisições
    console.log "Requested #{u.path}"
    # Executação uma ação
    action = @_getAction(u.pathname)
    if action?
      controller[action](req, res)
    else
      controller.error(req, res, 404)
    # Fecha a conexão
    res.end()

  # Obtém a ação a executar
  # de acordo com a url
  _getAction: (path) ->
    for r in @_routes
      if r.path == path
        return r.action
    null

# Exporta uma instancia da classe
module.exports = new Router()
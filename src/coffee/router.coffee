url        = require("url")
controller = require("./controller")

# O Router é responsável por
# interpretar as requisições e
# executar o método correto do
# controller
class Router
  # Rotas definidas para
  # os métodos do controller
  _routes: []

  # Adiciona/mapeia uma roda
  add: (path, action) ->
    @_routes.push
      path: path
      action: action
    return

  # Processa uma requisição,
  # executando um método do controller
  process: (req, res) =>
    u = url.parse req.url
    # Executação uma ação
    action = @_getAction u.pathname
    if action?
      controller[action](req, res)
      # Faz um log no console de todas as requisições
      console.log "[Requested: #{u.path}]",
        "[Logged user: #{controller.getLoggedUser()}]", "[200]"
    else
      controller.error req, res, 404
      # Faz um log no console de todas as requisições
      console.warn "[Requested: #{u.path}]",
        "[Logged user: #{controller.getLoggedUser()}]", "[404]"
    return

  # Obtém a ação a executar
  # de acordo com a url
  _getAction: (path) ->
    for r in @_routes
      if r.path == path
        return r.action
    return null

# Exporta uma instância da classe
module.exports = new Router()
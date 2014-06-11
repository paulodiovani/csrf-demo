qs   = require("querystring")
fs   = require("fs")
jade = require("jade")

config = require("../../config.json")

# O Controller contém a lógica da aplicação,
# executando as ações necessárias e
# renderizando as views
class Controller
  # Argumentos passados pelo `request`
  req: null
  res: null

  # Exibe a view de login
  login: (@req, @res) =>
    data =
      usename: null
    # Processa os dados enviados para login
    @_parsePost (post) =>
      if post
        for u in config.users
          console.log u, post
          if post.username is u.username and post.password is u.password
            data.username = post.username
            # TODO: Salvar informações de login nos cookies
            break
        data.errormessage = "Usuário e senha incorretos." if not data.logged?
      # Exibe a view
      @_render "login", data

  # Exibe cabeçalho e view de erro
  error: (@req, @res, code) ->
    view = "error#{code}"
    @_render view, null, code

  # Lê os dados enviados via POST
  _parsePost: (callback) ->
    body = ""
    @req.on "data", (chunk) ->
      body += chunk.toString()
    @req.on "end",=>
      post = qs.parse body if body isnt ""
      callback.call @, post

  # Renderiza uma view
  _render: (view, data = null, code = 200) ->
    viewPath = "views/#{view}.jade"
    # Lê e compila o template Jade
    tpl    = fs.readFileSync viewPath
    viewFn = jade.compile tpl.toString(), {filename: viewPath}
    # ...então renderiza o mesmo
    @res.writeHead code, {"Content-Type": "text/html"}
    @res.write viewFn(data)
    @res.end()

# Exporta uma instancia da classe
module.exports = new Controller()
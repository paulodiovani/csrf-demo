# O Controller contém a lógica da aplicação,
# executando as ações necessárias e
# renderizando as views

# Dependências requeridas
fs     = require("fs")
jade   = require("jade")

# Inicio da classe
class Controller
  # Argumentos passados pelo `request`
  req: null
  res: null

  # Exibe a view de login
  login: (@req, @res) =>
    @_render "login"

  # Exibe cabeçalho e view de erro
  error: (@req, @res, code) ->
    view = "error#{code}"
    @_render view, null, code

  # Renderiza uma view
  _render: (view, data = null, code = 200) ->
    viewPath = "views/#{view}.jade"
    # Lê e compila o template Jade
    tpl    = fs.readFileSync viewPath
    viewFn = jade.compile tpl.toString(), {filename: viewPath}
    # ...então renderiza o mesmo
    @res.writeHead code, {"Content-Type": "text/html"}
    @res.write viewFn()

# Exporta uma instancia da classe
module.exports = new Controller()
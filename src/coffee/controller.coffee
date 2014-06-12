url        = require("url")
qs         = require("querystring")
fs         = require("fs")
jade       = require("jade")
crypto     = require("crypto")
nodemailer = require("nodemailer")

config = require("../../config.json")

# O Controller contém a lógica da aplicação,
# executando as ações necessárias e
# renderizando as views
class Controller
  # Argumentos do `request`
  req: null
  res: null

  # Exibe a view de login
  login: (@req, @res) =>
    data =
      username: @getLoggedUser()
      pathname: @_urlPathname()
    # Processa os dados enviados para login
    @_parsePost (post) =>
      if post?
        md5 = crypto.createHash "md5"
        md5.update post.password
        md5pass = md5.digest "hex"

        if @_loginValid post.username, md5pass
          data.username = post.username
          hash = @_getCookieHash post.username, md5pass
          head = [200,
            "Set-Cookie": "login=#{hash}"
            "Content-Type": "text/html"]
        else
          data.errormessage = "Usuário e senha incorretos."
          head = null
      # Exibe a view
      @_render "login", data, head
    return

  # Descola o usuário
  logout: (@req, @res) =>
    @res.writeHead 302,
      "Set-Cookie": "login="
      "Location": "/"
    @res.end()
    return

  # Exibe o formulário de contato
  contact: (@req, @res) ->
    data =
      username: @getLoggedUser()
      pathname: @_urlPathname()
    # Processa os dados enviados via GET
    get = @_parseGet()
    if get?
      # Valida os dados
      if not get.fullname? or get.fullname is "" or
      not get.email? or get.email is "" or
      not get.subject? or get.subject is "" or
      not get.message? or get.message is ""
        data.errormessage = "Atenção: Todos os campos são obrigatórios."
      else
        # Envia e-mail
        smtpTransport = nodemailer.createTransport "SMTP",
          service: config.smtp_service
          auth:
            user: config.smtp_username
            pass: config.smtp_password

        mailOptions =
          from: "#{get.fullname} <#{get.email}>" # sender address
          to: config.contact_address             # list of receivers
          subject: get.subject                   # Subject line
          text: get.message                      # plaintext body

        smtpTransport.sendMail mailOptions, (error, response) =>
          if error
            data.errormessage = "Erro ao enviar mensagem"
            console.error error.stack or error
          else
            data.successmessage = "Mensagem enviada com sucesso"
            console.log "Mensagem enviada: #{response.message}"
          # Fecha o pool smtp e exibe a view
          smtpTransport.close()
          @_render "contact", data
        return

    @_render "contact", data
    return

  # Verifica se existe usuário logado
  # e rtorna o username caso sim
  getLoggedUser: ->
    cookies = @_parseCookie()
    if cookies.login
      for u in config.users
        [username, password] = u
        hash = @_getCookieHash username, password
        if hash is cookies.login
          return username
    return null

  # Exibe status e view de erro
  error: (@req, @res, code) ->
    view = "error#{code}"
    @_render view, null, [code, {"Content-Type": "text/html"}]
    return

  # Retorna o caminho requerido
  _urlPathname: ->
    u = url.parse @req.url
    return u.pathname

  # Valida se o usuário e senha são válidos
  _loginValid: (user, md5pass)->
    for u in config.users
      [username, password] = u
      if user is username and md5pass is password
        return true

    return false

  # Cria um hash para salvar/comparar no Cookie
  _getCookieHash: (user, md5pass) ->
    sha1 = crypto.createHash "sha1"
    sha1.update user
    sha1.update md5pass
    hash = sha1.digest "hex"

    return hash[..6]

  # Lê os dados enviados via POST
  _parsePost: (callback) ->
    body = ""
    @req.on "data", (chunk) ->
      body += chunk.toString()
    @req.on "end",=>
      post = qs.parse body if body isnt ""
      callback.call @, post
    return

  # Lê dados enviados via GET
  _parseGet: ->
    # Função que verifica se objeto é vazio
    empty = (obj) ->
      for k of obj
        return false
      true
    # Retorna a url query, se não for vazio
    # ou retorna null
    u = url.parse @req.url, true
    return u.query if not empty u.query
    return null

  # Lê os dados dos Cookies
  _parseCookie: ->
    list = {}
    rc = @req.headers.cookie
    if rc?
      for cookie in rc.split ";"
        [key, val] = cookie.split "="
        list[key] = val
    return list

  # Renderiza uma view
  _render: (view, data = null, head = null) ->
    viewPath = "views/#{view}.jade"
    # Lê e compila o template Jade
    tpl    = fs.readFileSync viewPath
    viewFn = jade.compile tpl.toString(), {filename: viewPath}
    # ...então renderiza o mesmo
    [code, obj] = if head? then head else [200, {"Content-Type": "text/html"}]
    @res.writeHead code, obj
    @res.write viewFn(data)
    @res.end()
    return

# Exporta uma instancia da classe
module.exports = new Controller()
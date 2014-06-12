# # CSRF App
#
# Uma aplicação simples para teste e demonstração de
# ataques [CSRF (_Cross-site request forgery_)][1]
#
# Fontes do projeto em https://github.com/paulodiovani/csrf-demo
#
# # index.coffee
#
# O script Index incia o servidor HTTP
# e controla as requisições e respostas
#
# [1]: http://en.wikipedia.org/wiki/Csrf

http   = require("http")
router = require("./router")

# Obtém a porta à escutar, ou `8082` por padrão
port = process.argv[2] || 8082

# Inicia um servidor HTTP
server = http.createServer()
server.listen port
console.log "Servidor rodando na porta #{port}"

# Adiciona as rotas da aplicação
router.add "/"       , "login"
router.add "/login"  , "login"
router.add "/logout" , "logout"
router.add "/contact", "contact"

# Escuta as requisições e
# as envia para o Router
server.on "request", router.process
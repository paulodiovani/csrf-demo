# O script Index incia o servidor HTTP
# e controla as requisições e respostas

# Dependências requeridas
http       = require("http")
router     = require("./router")

# Obtém a porta à escutar, ou `8082` por padrão
port = process.argv[2] || 8082

# Inicia um servidor HTTP
server = http.createServer()
server.listen port
console.log "Servidor rodando na porta #{port}"

# Adiciona as rotas da aplicação
router.add "/"     , "login"
router.add "/login", "login"

# Escuta as requisições e
# as envia para o Router
server.on "request", router.process
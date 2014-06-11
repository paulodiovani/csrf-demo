# CSRF App

Uma aplicação simples para teste e demonstração de ataques [CSRF (_Cross-site request forgery_)][1]

## Para executar localmente

Primeiramente você deve ter Node.js e NPM Instalados.

Então execute:

    git clone https://github.com/paulodiovani/csrf-demo.git
    cd csrf-demo
    npm install
    npm start

Depois disso basta acessar a aplicação em http://localhost:8082.

## Para desenvolver

Os fontes são escritos em CoffeeScript e validados e compilados com Grunt.

Primeiro instale as dependências:

    npm install -g coffee-script grunt-cli

Então apenas execute a _default task_ do Grunt, que irá validar os fontes, compilar, observar por modificações e iniciar o webserver.

    grunt


[1]: http://en.wikipedia.org/wiki/Csrf "Artigo na Wikipedia sobre CSRF (em inglês)"
# CSRF Demo App

Uma aplicação simples para teste e demonstração de ataques [CSRF (_Cross-site request forgery_)][1]

## [Documentação][2]

[Documentação dos fontes][2], gerada via [Docco](http://jashkenas.github.io/docco/).

[2]: http://paulodiovani.github.io/csrf-demo/

## Para executar localmente

Primeiramente você deve ter Node.js e NPM Instalados.
Então fazer um clone deste repositório.

    git clone https://github.com/paulodiovani/csrf-demo.git
    cd csrf-demo

Você deve configurar o servidor SMTP a utilizar e e-mail de contato no arquivo `config.json`.

    cp config.json.dist config.json
    # Edite utilizando vim, ou seu editor favorito
    vim config.json

Para instalar as dependências e iniciar a aplicação.

    npm install && npm start

Depois disso basta acessar em http://localhost:8082.

### Testes CSRF

O diretório `exploits/` contém páginas HTML com exemplos de ataques.

Você pode executálos abrindo as páginas diretamente no navegador ou acessando http://paulodiovani.github.io/csrf-demo/exploits/

## Para desenvolver

Os fontes são escritos em CoffeeScript e validados e compilados com Grunt.

Primeiro instale as dependências:

    npm install -g coffee-script grunt-cli

Então apenas execute a _default task_ do Grunt, que irá validar os fontes, compilar, observar por modificações e iniciar o webserver.

    grunt


[1]: http://en.wikipedia.org/wiki/Csrf "Artigo na Wikipedia sobre CSRF (em inglês)"
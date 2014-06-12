module.exports = (grunt) ->

  # project configuration
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    # Observe file modifications
    watch:
      gruntfile:
        files: ['Gruntfile.coffee']
        tasks: ['coffeelint:gruntfile']

      makecoffee:
        options:
          nospawn: true
        files: ['src/**/*.coffee', 'config.json']
        tasks: ['coffeelint:sources', 'coffee:node', 'develop']

    # Check for syntax
    coffeelint:
      gruntfile: ['Gruntfile.coffee']
      sources: ['src/coffee/*.coffee']
      options:
        configFile: 'coffeelint.json'

    # Compile files
    coffee:
      node:
        expand: true
        flatten: false
        cwd: 'src/coffee/'
        src: ['*.coffee']
        dest: './src/js/'
        ext: '.js'

    # Start a node app
    develop:
      webserver:
        file: './src/js/index.js'
        cmd: 'node'
        args: ["8082"]
        env: {NODE_ENV: 'development'}

  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-develop'

  # default task(s)
  grunt.registerTask 'default', [
    'coffeelint:gruntfile', 'coffeelint:sources'
    'coffee:node'
    'develop'
    'watch'
  ]

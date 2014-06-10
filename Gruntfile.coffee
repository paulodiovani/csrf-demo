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
        files: ['src/**/*.coffee']
        tasks: ['coffeelint:sources', 'coffee:node']

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

  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  # default task(s)
  grunt.registerTask 'default', [
    'coffeelint:gruntfile', 'coffeelint:sources'
    'coffee:node'
    'watch'
  ]
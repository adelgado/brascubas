module.exports = (grunt) ->

  grunt.initConfig
    copy:
      build:
        cwd: 'source'
        src: [ '**', '!**/*.styl', '!**/*.coffee' ]
        dest: 'build'
        expand: true

    clean:
      build:
        src: ['*.css', '*.js']

    # stylus:
    #   build:
    #     option:
    #       linenos: true
    #       compress: false

    #     files: [
    #       expand: true
    #       cwd: 'source'
    #       src: [ '**/*.styl']
    #       dest: 'build'
    #       ext: '.css'
    #     ]

    # autoprefixer:
    #   build:
    #     expand: true
    #     cwd: 'build'
    #     src: ['**/*.css']
    #     dest: ['build']

    coffee:
      build:
        expand: true
        cwd: 'source'
        src: ['**/*.coffee']
        dest: 'build'
        ext: '.js'

    watch:
      # stylesheets:
      #   files: 'source/**/*.styl'
      #   tasks: ['stylesheets']
      scripts:
        files: 'source/**/*.coffee'
        tasks: ['coffee']
      copy:
        files: [ 'source/**', '!source/**/*.styl', '!source/**/*.coffee' ]
        tasks: [ 'copy' ]

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  # grunt.loadNpmTasks 'grunt-contrib-stylus'
  # grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # grunt.registerTask 'stylesheets', [
  #   'stylus'
  #   'autoprefixer'
  # ]

  grunt.registerTask 'build', [
    'clean'
    'copy'
    # 'stylesheets'
    'coffee'
  ]

  grunt.registerTask 'default', ['build', 'watch']

gulp = require 'gulp'
jade = require 'gulp-jade'
del = require 'del'
bower = require 'gulp-bower-files'
flatten = require 'gulp-flatten'
uglify = require 'gulp-uglify'
cond   = require 'gulp-if'
inject = require 'gulp-inject'

conf =
  src: 'assets'
  dest: 'dest'
  prod: false


gulp.task 'clean', ->
  del [
    "#{conf.dest}/**/*"
  ]


gulp.task 'jade', ->
  gulp.src ["#{conf.src}/jade/**/*.jade", "!#{conf.src}/jade/**/_*.jade"]
    .pipe jade
      pretty: true
    .pipe inject(
      gulp.src("#{conf.dest}/js/lib/*.js", read: false),
      relative: true
    )
    .pipe gulp.dest "#{conf.dest}"


gulp.task 'bower', ->
  bower()
    .pipe cond conf.prod, uglify({preserveComments:'some'})
    .pipe flatten()
    .pipe (gulp.dest "#{conf.dest}/js/lib")


gulp.task 'default', [
    #'clean'
    #'bower'
    'jade'
  ]


gulp.task 'prod', ->
    conf.prod = true

gulp = require 'gulp'
jade = require 'gulp-jade'
del = require 'del'
bower = require 'gulp-bower-files'
flatten = require 'gulp-flatten'
uglify = require 'gulp-uglify'
cond   = require 'gulp-if'

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
    .pipe gulp.dest "#{conf.dest}"


gulp.task 'bower', ->
  bower()
    .pipe cond conf.prod, uglify({preserveComments:'some'})
    .pipe flatten()
    .pipe (gulp.dest "#{conf.dest}/js/lib")


gulp.task 'default', [
    # 'clean'
    'jade'
  ]

gulp.task 'prod', ->
    conf.prod = true

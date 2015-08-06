gulp = require 'gulp'
jade = require 'gulp-jade'
del = require 'del'

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


gulp.task 'default', [
    # 'clean'
    'jade'
  ]

gulp.task 'prod', ->
    conf.prod = true

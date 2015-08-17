gulp = require 'gulp'
$ = require('gulp-load-plugins')()
del = require 'del'
browserSync = require 'browser-sync'
runSequence = require 'run-sequence'

conf =
  src: 'assets'
  dest: 'dest'
  prod: false


gulp.task 'clean', ->
  return del [
    "#{conf.dest}/**/*"
  ]


gulp.task 'jade', ->
  return gulp.src ["#{conf.src}/jade/**/!(_)*.jade"]
    .pipe $.plumber
      errorHandler: $.notify.onError('<%= error.message %>')
    .pipe $.jade
      pretty: true
    # .pipe $.inject(
    #   gulp.src("#{conf.src}/js/lib/*.js", read: false)
    # )
    .pipe gulp.dest "#{conf.dest}"
    .pipe browserSync.reload
      stream: true


gulp.task 'sass', ->
  return $.rubySass("#{conf.src}/sass/", {
      bundleExec: true,
      compass: true
    })
    .on 'error', (err)->
      console.error 'Error!', err.message
    .pipe $.autoprefixer
      browsers: ['last 2 versions']
      cascade: true
    .pipe $.if conf.prod, $.minifyCss()
    .pipe gulp.dest "#{conf.dest}/css"
    .pipe browserSync.reload
      stream: true


gulp.task 'bower', ->
  return $.bowerFiles()
    .pipe $.if conf.prod, $.uglify({preserveComments:'some'})
    .pipe $.flatten()
    .pipe (gulp.dest "#{conf.dest}/js/lib")


gulp.task 'js', ->
  return gulp.src ["#{conf.src}/js/**/*"]
    .pipe gulp.dest "#{conf.dest}/js/"
    .pipe browserSync.reload
      stream: true


gulp.task 'copy:img', ->
  return gulp.src ["#{conf.src}/img/!(_)**/*"]
    .pipe gulp.dest "#{conf.dest}/img/"


gulp.task "browser-sync", ->
  browserSync.init null,
    server: conf.dest
    reloadDelay: 2000


gulp.task 'watch', ['browser-sync'], ->
  $.watch ["#{conf.src}/**/*.{jade,_jade}"], ->
    gulp.start 'jade'
  $.watch ["#{conf.src}/**/*.scss"], ->
    gulp.start 'sass'
  $.watch ["#{conf.src}/js/**/*"], ->
    gulp.start 'js'
  $.watch ["#{conf.src}/**/*.png"], ->
    gulp.start 'copy:img'


# server
gulp.task 'server', ->
  runSequence(
    'clean'
    # 'bower'
    ['jade', 'js', 'copy:img']
    'watch'
  )


# default
gulp.task 'default', [
    #'clean'
    #'bower'
    'jade'
  ]


# prod
gulp.task 'prod', ->
    conf.prod = true

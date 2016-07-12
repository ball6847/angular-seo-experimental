gulp                  = require 'gulp'
coffee                = require 'gulp-coffee'
newer                 = require 'gulp-newer'
less                  = require 'gulp-less'
jade                  = require 'gulp-pug'
ngAnnotate            = require 'gulp-ng-annotate'
del                   = require 'del'
browsersync           = require 'browser-sync'
plumber               = require 'gulp-plumber'
gutil                 = require 'gulp-util'
runseq                = require 'run-sequence'
_                     = require 'lodash'
appfiles              = require './lib/scan-app-files'
createBundles         = require './lib/create-bundles'
pkg                   = require './package.json'

# --------------------------------------------------------------------

buildEnv = (process.env.NODE_ENV or 'development').trim().toLowerCase()
devBuild = buildEnv != 'production'
src = 'src/'
dest = 'build/'

plumberHandler = (error) ->
  gutil.log gutil.colors.red('Error (' + error.plugin + '): ' + error.message)
  @emit 'end'
  return

console.log pkg.name + ' ' + pkg.version + ', ' + buildEnv + ' build'

# --------------------------------------------------------------------
# add custom browserify options here

bundles = [
  {
    input    : ['src/front/app.coffee']
    output   : 'app.js'
    transform  : ['coffeeify']
    extensions : ['.coffee']
    destination: 'build/front/'
  }
  {
    input    : ['src/app/app.coffee']
    output   : 'app.js'
    transform  : ['coffeeify']
    extensions : ['.coffee']
    destination: 'build/app/'
  }
]

gulp.task 'compile', ->
  taskArgs = process.argv.slice(2, process.argv.length)
  if 'build' in taskArgs then createBundles(bundles) else createBundles(bundles, true, browsersync)


# --------------------------------------------------------------------

tasks =
  clean: callback: ->
    del [
      dest + '*'
      "!#{ dest }/bower_components"
    ]
    return
  browsersync:
    callback: ->
      middleware = []
      browsersync
        server:
          baseDir: dest
          index: 'index.html'
          middleware: middleware
        open: false
        notify: false
        ghostMode: false
  assets:
    src: [
      "#{src}*/assets/**/*.*"
      "!#{src}*/assets/*.less"
    ]
    dest: dest
    callback: ->
      gulp.src(tasks.assets.src)
        .pipe(gulp.dest(tasks.assets.dest))
        .pipe browsersync.reload(stream: true)
  sharedassets:
    src: [
      "#{src}assets/**/*.*"
      "!#{src}assets/app.less"
    ]
    dest: "#{dest}assets/"
    callback: ->
      gulp.src(tasks.sharedassets.src)
        .pipe(gulp.dest(tasks.sharedassets.dest))
        .pipe browsersync.reload(stream: true)
  areaassets:
    src: "#{src}*/assets/**/*.*"
    dest: "#{dest}"
    callback: ->
      gulp.src(tasks.areaassets.src)
        .pipe(gulp.dest(tasks.areaassets.dest))
        .pipe browsersync.reload(stream: true)
  templates:
    src: "#{src}**/*.html"
    dest: dest
    callback: ->
      gulp.src(tasks.templates.src)
        .pipe(newer(tasks.templates.dest))
        .pipe(gulp.dest(tasks.templates.dest))
        .pipe browsersync.reload(stream: true)
  jade:
    src: "#{src}**/*.jade"
    dest: dest
    callback: ->
      vars = appfiles: appfiles
      gulp.src(tasks.jade.src)
        .pipe(jade(data: vars, pretty: true))
        .pipe(gulp.dest(tasks.jade.dest))
        .pipe browsersync.reload(stream: true)
  less:
    src: [
      "#{src}**/*.less"
    ]
    dest: dest
    callback: ->
      gulp.src(tasks.less.src)
        .pipe(newer(dest: tasks.less.dest, ext: '.css'))
        .pipe(plumber(plumberHandler))
        .pipe(less())
        .pipe(gulp.dest(tasks.less.dest))
        .pipe browsersync.reload(stream: true)

# --------------------------------------------------------------------
# allow local override

try
  require('./local') tasks
catch _error
  error = _error

# --------------------------------------------------------------------
# register tasks

_.forEach tasks, (task, name) ->
  gulp.task name, task.deps or [], task.callback
  return

# --------------------------------------------------------------------
# register watcher

gulp.task 'watch', ->
  _.forEach tasks, (task, name) ->
    if task.src and name != 'bower'
      gulp.watch task.src, [ name ]
    return
  return


# --------------------------------------------------------------------
# clean

gulp.task 'default', ->
  runseq 'assets', 'sharedassets', 'areaassets', 'templates', 'compile', 'less', 'jade', 'watch', 'browsersync'
  return

# --------------------------------------------------------------------
# just build, no watch or reload

gulp.task 'build', ->
  runseq 'clean', 'assets', 'sharedassets', 'areaassets', 'templates', 'compile', 'less', 'jade'
  return

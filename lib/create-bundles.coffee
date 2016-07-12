gulp       = require 'gulp'
watchify   = require 'watchify'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
colors     = require 'colors'

# mod from - https://gist.github.com/kyohei8/097b859efeb5bfddcd2d

createBundle = (options, watch = false, browsersync = null) ->
  opts =
    entries  : options.input
    extensions : options.extensions
    transform  : options.transform
    debug    : true

  bundler = if watch then watchify(browserify(opts)) else browserify(opts)

  rebundle = ->
    startTime = new Date().getTime()
    b = bundler.bundle()
      .on 'error', ->
        console.log arguments
      .pipe(source(options.output))
      .pipe gulp.dest(options.destination)
      .on 'end', ->
        time = (new Date().getTime() - startTime) / 1000
        console.log "#{options.output.cyan} was browserified: #{(time + 's').magenta}"

    if browsersync
      b.pipe(browsersync.reload(stream: true))

    return bundler

  rebundle().on('update', rebundle)

createBundles = (bundles, watch = false, browsersync = null) ->
  bundles.forEach (bundle) ->
    createBundle bundle, watch, browsersync

# ============================================

module.exports = createBundles

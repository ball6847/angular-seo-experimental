mainBowerFiles = require 'main-bower-files'
glob = require 'glob'
_ = require 'lodash'

module.exports = (group, base) ->
  group = group or null
  base = base or './'
  scope = group or 'app'
  js = []
  css = []

  rewriter =
    app: (path) ->
      path = path.replace(/^\.\/src\/(.*?)\.coffee$/g, base + '$1.js')
      path
    bower: (path) ->
      path = path.replace(/^.*?(bower_components.*?)$/g, base + '$1')
      path

  # first, add files from library
  _.forEach mainBowerFiles(
    paths: './'
    group: group), (file) ->
    file = rewriter.bower(file)
    if file.match(/\.js$/)
      return js.push(file)
    if file.match(/\.css$/)
      return css.push(file)
    return

  return {
    javascript: js
    stylesheet: css
  }

Router = require './routes'

app = angular.module 'app', [
  'ui.router'
  'viewhead'
]

app.constant 'config',
  url:
    app: 'front'
    assets: 'assets'
    vendors: 'bower_components'
  uiView: "<div class=\"fade-in-left-big\" ui-view></div>"

app.config ($urlRouterProvider, $urlMatcherFactoryProvider, $locationProvider, config) ->
  $urlRouterProvider.otherwise '/'
  $urlMatcherFactoryProvider.strictMode false
  $locationProvider.html5Mode false
  $locationProvider.hashPrefix '!'

app.config Router

app.run () ->
  return

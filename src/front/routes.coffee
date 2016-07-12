
module.exports = ($stateProvider, config) ->
  $stateProvider
    .state 'home',
      url: '/',
      templateUrl: "/front/templates/layout.html"

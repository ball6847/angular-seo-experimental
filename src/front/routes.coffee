FrontController = require './controllers/front'

module.exports = ($stateProvider, config) ->
  $stateProvider
    .state 'front',
      abstract: true
      url: '/',
      controller: FrontController
      templateUrl: "/front/templates/layout.html"
    .state 'front.home',
      url: '',
      templateUrl: "/front/templates/home.html"
      resolve:
        $title: () -> "Home"
    .state 'front.why',
      url: 'why',
      templateUrl: "/front/templates/why.html"
      resolve:
        $title: () -> "Why"
    .state 'front.about',
      url: 'about',
      templateUrl: "/front/templates/about.html"
      resolve:
        $title: () -> "About"
    .state 'front.contact',
      url: 'contact',
      templateUrl: "/front/templates/contact.html"
      resolve:
        $title: () -> "Contact"

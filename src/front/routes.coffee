
module.exports = ($stateProvider, config) ->
  $stateProvider
    .state 'front',
      abstract: true
      url: '/',
      templateUrl: "/front/templates/layout.html"
    .state 'front.home',
      url: '',
      templateUrl: "/front/templates/home.html"
    .state 'front.portfolio',
      url: 'portfolio',
      templateUrl: "/front/templates/portfolio.html"
    .state 'front.about',
      url: 'about',
      templateUrl: "/front/templates/about.html"
    .state 'front.contact',
      url: 'contact',
      templateUrl: "/front/templates/contact.html"


module.exports = ($stateProvider, config) ->
  $stateProvider
    .state 'front',
      abstract: true
      url: '/',
      templateUrl: "/front/templates/layout.html"
    .state 'front.home',
      url: '',
      templateUrl: "/front/templates/home.html"
      resolve:
        $title: () -> "Home"
    .state 'front.portfolio',
      url: 'portfolio',
      templateUrl: "/front/templates/portfolio.html"
      resolve:
        $title: () -> "Portfolio"
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

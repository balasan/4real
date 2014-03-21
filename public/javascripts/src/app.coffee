"use strict"

app = angular.module("4real", [
  "4real.filters", 
  "4real.services", 
  "4real.directives", 
  "4real.controllers", 
  "ui.router", 
  "ngAnimate",
  # "ngSanitize"
  # "angularMoment",
])
app.config ["$locationProvider","$stateProvider","$urlRouterProvider", ($locationProvider,$stateProvider, $urlRouterProvider) ->
  
  $locationProvider.html5Mode(true).hashPrefix('!');

  $urlRouterProvider.otherwise("/");
  # $stateProvider.when "/liquid",
  #   templateUrl: "/partials/liquid"
  #   controller: 'mainCtrl' 

  # $urlRouterProvider.otherwise("/");

  # $urlRouterProvider.when "/:page",
    # templateUrl: "/partials/main"
    # controller: 'mainCtrl'  

  $stateProvider.state "liquid",
    url: "/liquid"
    templateUrl: "/partials/liquid"

  $stateProvider.state "index",
    url: "/"
    templateUrl: "/partials/main"
    page: ''
  
  $stateProvider.state "index.about",
    url: "about"
    page: "about"

  $stateProvider.state "index.charts",
    url: "charts"
    page: "charts"

  $stateProvider.state "index.projects",
    url: "projects"
    page: "projects"

  # $stateProvider.when "/:page",
  #   templateUrl: "/partials/main"
  #   # controller: 'mainCtrl'  

  # $stateProvider.otherwise
  #   redirectTo: '/'

  # $routeProvider.when "/projects",
  #   templateUrl: "/partials/index"
  #   # controller: 'mainCtrl'

  # $routeProvider.when "/about",
  #   templateUrl: "/partials/index"
  #   # controller: 'mainCtrl'

]
# app.config ['$momentProvider', ($momentProvider)->
#     $momentProvider
#       .asyncLoading(false)
#       # .scriptUrl('//cdnjs.cloudflare.com/ajax/libs/moment.js/2.5.1/moment.min.js');
# ]
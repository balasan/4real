"use strict"

app = angular.module("4real", [
  "4real.filters", 
  "4real.services", 
  "4real.directives", 
  "4real.controllers", 
  "ngRoute", 
  "ngAnimate", 
  # "angularMoment",
])
app.config ["$routeProvider","$locationProvider", ($routeProvider, $locationProvider) ->
  
  $locationProvider.html5Mode(true)

  # $routeProvider.when "/",
    # templateUrl: "/partials/index"
    # controller: 'mainCtrl'  

  $routeProvider.when "/:page",
    # templateUrl: "/partials/index"
    # controller: 'mainCtrl'  

  $routeProvider.otherwise
    redirectTo: '/'

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
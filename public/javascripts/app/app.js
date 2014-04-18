(function() {
  "use strict";
  var app;

  app = angular.module("4real", ["4real.filters", "4real.services", "4real.directives", "4real.controllers", "ui.router", "ngAnimate"]);

  app.config([
    "$locationProvider", "$stateProvider", "$urlRouterProvider", function($locationProvider, $stateProvider, $urlRouterProvider) {
      $locationProvider.html5Mode(true).hashPrefix('!');
      $stateProvider.state("liquid", {
        url: "/liquid",
        templateUrl: "/partials/liquid",
        page: 'liquid',
        reload: true
      });
      $stateProvider.state("index", {
        url: "/",
        templateUrl: "/partials/main",
        page: '',
        reload: true
      });
      $stateProvider.state("auto", {
        url: "/auto",
        templateUrl: "/partials/main",
        page: 'auto'
      });
      $stateProvider.state("index.about", {
        url: "about",
        page: "about"
      });
      $stateProvider.state("index.charts", {
        url: "charts",
        page: "charts"
      });
      return $stateProvider.state("index.projects", {
        url: "projects",
        page: "projects"
      });
    }
  ]);

}).call(this);

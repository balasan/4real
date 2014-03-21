// Generated by CoffeeScript 1.3.3
(function() {
  "use strict";

  var app;

  app = angular.module("4real", ["4real.filters", "4real.services", "4real.directives", "4real.controllers", "ui.router", "ngAnimate"]);

  app.config([
    "$locationProvider", "$stateProvider", "$urlRouterProvider", function($locationProvider, $stateProvider, $urlRouterProvider) {
      $locationProvider.html5Mode(true);
      $urlRouterProvider.otherwise("/");
      $stateProvider.state("liquid", {
        url: "/liquid",
        templateUrl: "/partials/liquid"
      });
      $stateProvider.state("index", {
        url: "/",
        templateUrl: "/partials/main",
        page: ''
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

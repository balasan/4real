// Generated by CoffeeScript 1.3.3
(function() {
  var app;

  app = angular.module("4real.controllers", []);

  app.controller('aboutCtrl', ['$scope', function($scope) {}]);

  app.controller('mainCtrl', [
    '$scope', '$route', function($scope, $route) {
      $scope.rotate = {};
      $scope.rotate.y = 0;
      $scope.waterView = null;
      $scope.videos = ['v0', 'v1', 'v2', 'v3'];
      $scope.activeVideo = 0;
      $scope.playNextVideo = function() {
        return $scope.activeVideo = ($scope.activeVideo + 1) % $scope.videos.length;
      };
      return $scope.$on('$routeChangeSuccess', function(e, newL, oldL) {
        var angle, rotations;
        $scope.page = $route.current.params.page;
        rotations = ~~($scope.rotate.y / 360);
        angle = $scope.rotate.y % 360;
        console.log($route.current.params.page);
        switch ($route.current.params.page) {
          case void 0:
            $scope.rotate.y = 0 + 360 * rotations;
            return $scope.activeVideo = 2;
          case "charts":
            $scope.activeVideo = 0;
            if (angle > -90) {
              return $scope.rotate.y = 90 + 360 * rotations;
            } else {
              return $scope.rotate.y = -270 + 360 * rotations;
            }
            break;
          case "projects":
            $scope.activeVideo = 1;
            if (angle < 90) {
              return $scope.rotate.y = -90 + 360 * rotations;
            } else {
              return $scope.rotate.y = 270 + 360 * rotations;
            }
            break;
          case "about":
            $scope.activeVideo = 3;
            if (angle > 0) {
              return $scope.rotate.y = 180 + 360 * rotations;
            } else {
              return $scope.rotate.y = -180 + 360 * rotations;
            }
        }
      });
    }
  ]);

  app.controller("projectsCtrl", [
    '$scope', 'projectsService', '$timeout', function($scope, projectsService, $timeout) {
      $scope.projects = [];
      return $timeout(function() {
        return $scope.projects = projectsService.projects;
      }, 1000);
    }
  ]);

  app.controller("chartsCtrl", [
    '$scope', 'socket', '$timeout', 'btcHistory', '$filter', 'exchange', function($scope, socket, $timeout, btcHistory, $filter, exchange) {
      var convert;
      $scope.btcData = {};
      $scope.history = [];
      $scope.filtered = {};
      $scope.trim = 60;
      $scope.up = true;
      $scope.USD = '0.00';
      $scope.CNY = '0.00';
      $scope.RUB = '0.00';
      $scope.EUR = '0.00';
      $scope.GBP = '0.00';
      $scope.JPY = '0.00';
      convert = function() {
        if ($scope.USD === '0.00' || !$scope.rates[0]) {
          return;
        }
        return $scope.rates.forEach(function(rate) {
          return $scope[rate.id.slice(0, 3)] = $scope.USD / parseFloat(rate.Rate);
        });
      };
      $scope.data;
      $scope.history = $filter('btcData')($scope.data);
      $scope.USD = $scope.history[$scope.history.length - 1].price;
      convert();
      window.prerenderReady = true;
      return socket.on('btc-data', function(data) {
        $scope.btcData = $filter('btcData')(data.data);
        $scope.USD = parseFloat($scope.btcData.last);
        if ($scope.btcData.date <= $scope.history[$scope.history.length - 1].date) {
          return;
        }
        if ($scope.history[0] && $scope.USD > $scope.history[$scope.history.length - 1].price) {
          $scope.up = true;
        } else if ($scope.history[0] && $scope.USD < $scope.history[$scope.history.length - 1].price) {
          $scope.up = false;
        }
        if ($scope.history[0]) {
          $scope.history.push($scope.btcData);
        }
        return convert();
      });
    }
  ]);

}).call(this);

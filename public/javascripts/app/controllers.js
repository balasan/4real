// Generated by CoffeeScript 1.3.3
(function() {
  var app;

  app = angular.module("4real.controllers", []);

  app.controller('aboutCtrl', ['$scope', function($scope) {}]);

  app.controller('mainCtrl', [
    '$scope', '$route', function($scope, $route) {
      $scope.rotate = {};
      $scope.rotate.y = 0;
      return $scope.$on('$routeChangeSuccess', function(e, newL, oldL) {
        var angle, rotations;
        $scope.page = $route.current.params.page;
        rotations = ~~($scope.rotate.y / 360);
        angle = $scope.rotate.y % 360;
        console.log($route.current.params.page);
        switch ($route.current.params.page) {
          case void 0:
            return $scope.rotate.y = 0 + 360 * rotations;
          case "charts":
            if (angle > -90) {
              return $scope.rotate.y = 90 + 360 * rotations;
            } else {
              return $scope.rotate.y = -270 + 360 * rotations;
            }
            break;
          case "projects":
            if (angle < 90) {
              return $scope.rotate.y = -90 + 360 * rotations;
            } else {
              return $scope.rotate.y = 270 + 360 * rotations;
            }
            break;
          case "about":
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
      var convert, getData, getRates;
      socket.on('init', function(data) {
        return getData();
      });
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
      $scope.rates = {};
      convert = function() {
        if ($scope.USD === '0.00' || !$scope.rates[0]) {
          return;
        }
        return $scope.rates.forEach(function(rate) {
          return $scope[rate.id.slice(0, 3)] = $scope.USD / parseFloat(rate.Rate);
        });
      };
      getRates = function() {
        return exchange.getRates(function(rates) {
          if (!rates.results) {
            $timeout(getRates, 5000);
            return;
          }
          $scope.rates = rates.results.rate;
          return convert();
        });
      };
      getRates();
      getData = function() {
        return socket.emit('getData', $scope.trim, function(data) {
          console.log(data);
          $scope.history = $filter('btcData')(data);
          console.log($scope.history);
          $scope.USD = $scope.history[$scope.history.length - 1].price;
          return convert();
        });
      };
      return socket.on('btc-data', function(data) {
        $scope.btcData = $filter('btcData')(data.data);
        console.log($scope.btcData);
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

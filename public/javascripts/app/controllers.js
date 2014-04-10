(function() {
  var app;

  app = angular.module("4real.controllers", []);

  app.controller('aboutCtrl', ['$scope', function($scope) {}]);

  app.controller('mainCtrl', [
    '$scope', '$timeout', '$rootScope', 'siteMap', function($scope, $timeout, $rootScope, siteMap) {
      $scope.rotate = {};
      $scope.rotate.y = 0;
      $scope.waterView = null;
      $scope.videos = ['v0', 'v1', 'v2', 'v3'];
      $scope.activeVideo = 0;
      $scope.page = '';
      $scope.loadedImg = 0;
      $scope.title = "4real Digital Agency";
      $scope.playNextVideo = function() {
        return $scope.activeVideo = ($scope.activeVideo + 1) % $scope.videos.length;
      };
      return $rootScope.$on('$stateChangeStart', function(e, newState, oldState) {
        var angle, rotations;
        $scope.page = newState.page;
        rotations = ~~($scope.rotate.y / 360);
        angle = $scope.rotate.y % 360;
        switch ($scope.page) {
          case '':
            $scope.rotate.y = 0 + 360 * rotations;
            $scope.activeVideo = 2;
            $scope.title = siteMap.main.title;
            $scope.description = siteMap.main.description;
            $scope.keywords = siteMap.main.keywords;
            break;
          case "charts":
            $scope.activeVideo = 0;
            if (angle > -90) {
              $scope.rotate.y = 90 + 360 * rotations;
            } else {
              $scope.rotate.y = -270 + 360 * rotations;
            }
            $scope.title = siteMap.charts.title;
            $scope.description = siteMap.charts.description;
            $scope.keywords = siteMap.charts.keywords;
            break;
          case "projects":
            $scope.activeVideo = 1;
            if (angle < 90) {
              $scope.rotate.y = -90 + 360 * rotations;
            } else {
              $scope.rotate.y = 270 + 360 * rotations;
            }
            $scope.title = siteMap.projects.title;
            $scope.description = siteMap.projects.description;
            $scope.keywords = siteMap.projects.keywords;
            break;
          case "about":
            $scope.activeVideo = 3;
            if (angle > 0) {
              $scope.rotate.y = 180 + 360 * rotations;
            } else {
              $scope.rotate.y = -180 + 360 * rotations;
            }
            $scope.title = siteMap.about.title;
            $scope.description = siteMap.about.description;
            $scope.keywords = siteMap.about.keywords;
            break;
          case "liquid":
            $scope.title = siteMap.liquid.title;
            $scope.description = siteMap.liquid.description;
            $scope.keywords = siteMap.liquid.keywords;
        }
        return $scope.$broadcast('page', $scope.page);
      });
    }
  ]);

  app.controller("projectsCtrl", [
    '$scope', 'projectsService', '$timeout', function($scope, projectsService, $timeout) {
      $scope.projects = [];
      $scope.$on('page', function(e, page) {
        if (page === "projects") {
          return $scope.loadProjects();
        }
      });
      $scope.loadProjects = function() {
        if ($scope.projects[0] === void 0) {
          return $scope.projects = projectsService.projects;
        }
      };
      if ($scope.$parent.page === 'projects') {
        $scope.loadProjects();
      }
      return $timeout($scope.loadProjects, 10000);
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
      return socket.on('btcData', function(data) {
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

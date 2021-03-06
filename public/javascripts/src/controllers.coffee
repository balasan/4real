app =  angular.module("4real.controllers", [])

app.controller 'aboutCtrl', ['$scope', ($scope) ->

  # $scope.text = [
  #   "4Real is a global creative agency based in New York City."
  #   ,"We provide high quality multi-platform creative web services, "
  #   ,"full range of strategic consulting services, "
  #   ,"and deliver an array of innovative and flexible services to businesses of all sizes."
  #   ,"We design & build efficient and scalable technology-driven websites & systems including:"
  #   ,"social integration and engagement,"
  #   ,"3D visualization,"
  #   ,"interactive media,"
  #   ,"realtime technologies,"
  #   ,"custom CMS"
  #   ,"..."
  #   ,"But most importantly,"
  #   ,"we come up with culturally relevant methods to present information in a wide veriety of media"
  # ]

]

app.controller 'mainCtrl', [ '$scope', '$timeout','$rootScope','siteMap',"$location", ($scope, $timeout,$rootScope,siteMap,$location) ->
  $scope.rotate = {}
  $scope.rotate.y=0;
  $scope.waterView = null;

  # $scope.videos = ['v0', 'v1', 'v2', 'v3'];
  $scope.videos = ['v0','v0','v0','v0'];

  $scope.activeVideo = 0;
  $scope.page='';
  $scope.loadedImg =0;

  $scope.title = "4real Digital Agency"

  $scope.$watch 'page', (newP, oldP) ->
    if oldP == 'liquid' and newP !='liquid'
      null
      # window.location.reload();

  $scope.playNextVideo = ()->
    $scope.activeVideo = ($scope.activeVideo + 1) % $scope.videos.length
 
  # $scope.playNextVideo()

  $rootScope.$on '$stateChangeStart', (e, newState, oldState)->
    $scope.page = newState.page
    rotations = ~~($scope.rotate.y / 360)
    angle = $scope.rotate.y % 360
    switch $scope.page               
      when ''
        $scope.rotate.y = 0 + 360*rotations
        $scope.activeVideo = 2
        $scope.title = siteMap.main.title
        $scope.description = siteMap.main.description
        $scope.keywords = siteMap.main.keywords
        $scope.fbimg = siteMap.main.fbimg
      when "charts" 
        $scope.activeVideo = 0
        if (angle > -90) then $scope.rotate.y = 90 + 360*rotations
        else $scope.rotate.y = -270 + 360*rotations
        $scope.title = siteMap.charts.title
        $scope.description = siteMap.charts.description
        $scope.keywords = siteMap.charts.keywords
        $scope.fbimg = siteMap.charts.fbimg
      when "projects"
        $scope.activeVideo = 1  
        if(angle < 90)
          $scope.rotate.y = -90 + 360*rotations
        else $scope.rotate.y = 270 + 360*rotations
        $scope.title = siteMap.projects.title
        $scope.description = siteMap.projects.description
        $scope.keywords = siteMap.projects.keywords
        $scope.fbimg = siteMap.projects.fbimg
      when "about" 
        $scope.activeVideo = 3 
        if(angle >0)
          $scope.rotate.y = 180 + 360*rotations
        else $scope.rotate.y = -180 + 360*rotations
        $scope.title = siteMap.about.title
        $scope.description = siteMap.about.description
        $scope.keywords = siteMap.about.keywords
        $scope.fbimg = siteMap.about.fbimg
      when "liquid"
        $scope.title = siteMap.liquid.title
        $scope.description = siteMap.liquid.description
        $scope.keywords = siteMap.liquid.keywords
        $scope.fbimg = siteMap.liquid.fbimg
     $scope.$broadcast('page', $scope.page)

]

app.controller "projectsCtrl", [ '$scope','projectsService','$timeout', ($scope,projectsService,$timeout)->
  
  $scope.projects=[]

  $scope.viewproject = 0

  $scope.$on 'page', (e,page)->
    if page=="projects"
      $scope.loadProjects()
      # body...)

  $scope.loadProjects = ()->
    if($scope.projects[0]==undefined)
      $scope.projects = projectsService.projects
 
  if $scope.$parent.page=='projects'
    $scope.loadProjects()

  $timeout $scope.loadProjects, 1000

]

app.controller "chartsCtrl", [ '$scope','socket','$timeout','btcHistory','$filter', 'exchange', ($scope,socket,$timeout,btcHistory,$filter, exchange)->

  # socket.on 'init', (data)->
    # getData()

  $scope.btcData = {};
  $scope.history = [];
  $scope.filtered ={}

  $scope.trim = 60;

  $scope.up = true;

  $scope.USD = '0.00'
  $scope.CNY = '0.00'
  $scope.RUB = '0.00'
  $scope.EUR = '0.00'
  $scope.GBP = '0.00'
  $scope.JPY = '0.00'

  convert = ()->
    if $scope.USD == '0.00' || $scope.rates == {} || !$scope.rates
      return
    return Object.keys($scope.rates).forEach (curr)->
      return $scope[curr.replace('USD', '')] = $scope.USD * parseFloat($scope.rates[curr])

  $scope.data

  $scope.history = $filter('btcData')($scope.data);
  $scope.USD = $scope.history[$scope.history.length - 1].price
  convert()

  window.prerenderReady = true

        # body...
  socket.on 'btcData', (data)->
    $scope.btcData = $filter('btcData')(data.data)
    # console.log($scope.btcData)
    $scope.USD = parseFloat($scope.btcData.last)
    
    if $scope.btcData.date <= $scope.history[$scope.history.length - 1].date
      return 

    if $scope.history[0] && $scope.USD > $scope.history[$scope.history.length - 1].price
      $scope.up = true;
    else if $scope.history[0] && $scope.USD < $scope.history[$scope.history.length - 1].price then  $scope.up = false;
    
    if($scope.history[0])
      $scope.history.push($scope.btcData) 
    convert();
      # $scope.filtered = $filter('btcAverage')($scope.history);

]
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

app.controller 'mainCtrl', [ '$scope', '$route', ($scope, $route) ->
  $scope.rotate = {}
  $scope.rotate.y=0;
  $scope.waterView = null;

  $scope.videos = ['v0', 'v1', 'v2', 'v3'];
  $scope.activeVideo = 0;

  $scope.playNextVideo = ()->
    $scope.activeVideo = ($scope.activeVideo + 1) % $scope.videos.length


  $scope.$on '$routeChangeSuccess', (e, newL, oldL)->
    $scope.page = $route.current.params.page
    # $scope.$apply()
    rotations = ~~($scope.rotate.y / 360)
    angle = $scope.rotate.y % 360
    console.log $route.current.params.page
    switch $route.current.params.page                
      when undefined
        $scope.rotate.y = 0 + 360*rotations
        $scope.activeVideo = 2
      when "charts" 
        $scope.activeVideo = 0
        if (angle > -90) then $scope.rotate.y = 90 + 360*rotations
        else $scope.rotate.y = -270 + 360*rotations
      when "projects"
        $scope.activeVideo = 1  
        if(angle < 90)
          $scope.rotate.y = -90 + 360*rotations
        else $scope.rotate.y = 270 + 360*rotations
      when "about" 
        $scope.activeVideo = 3 
        if(angle >0)
          $scope.rotate.y = 180 + 360*rotations
        else $scope.rotate.y = -180 + 360*rotations

]

app.controller "projectsCtrl", [ '$scope','projectsService','$timeout', ($scope,projectsService,$timeout)->
  $scope.projects=[]
  $timeout(()->
    $scope.projects = projectsService.projects
  1000)

]

app.controller "chartsCtrl", [ '$scope','socket','$timeout','btcHistory','$filter', 'exchange', ($scope,socket,$timeout,btcHistory,$filter, exchange)->

  socket.on 'init', (data)->
    getData()

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
  $scope.rates ={}

  convert = ()->
    if $scope.USD=='0.00' || !$scope.rates[0]
      return
    $scope.rates.forEach (rate)->
      $scope[rate.id.slice(0,3)] = $scope.USD / parseFloat(rate.Rate)
      # console.log($scope[rate.id.slice(0,3)])


  getRates = ()->
    exchange.getRates (rates)->
      if !rates.results
        $timeout(getRates, 5000)
        # getRates
        return
      $scope.rates = rates.results.rate
      convert()
  getRates()

  getData = ()->
    socket.emit 'getData', $scope.trim, (data) ->
      # console.log(data)
      $scope.history = $filter('btcData')(data);
      # console.log($scope.history)
      $scope.USD = $scope.history[$scope.history.length - 1].price
      convert()

        # body...
  socket.on 'btc-data', (data)->
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
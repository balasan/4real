app =  angular.module("4real.controllers", [])

app.controller 'aboutCtrl', ['$scope', ($scope) ->

  $scope.text = [
    "4Real is a global creative agency based in New York City."
    ,"We provide high quality multi-platform creative web services, "
    ,"full range of strategic consulting services, "
    ,"and deliver an array of innovative and flexible services to businesses of all sizes."
    ,"We design & build efficient and scalable technology-driven websites & systems including:"
    ,"social integration and engagement,"
    ,"3D visualization,"
    ,"interactive media,"
    ,"realtime technologies,"
    ,"custom CMS"
    ,"..."
    ,"But most importantly,"
    ,"we come up with culturally relevant methods to present information in a wide veriety of media"
    
  ]

]

app.controller 'mainCtrl', [ '$scope', '$route', ($scope, $route) ->
  $scope.rotate = {}
  $scope.rotate.y=0;
  $scope.$on '$routeChangeSuccess', (e, newL, oldL)->
    $scope.page = $route.current.params.page
    # $scope.$apply()
    rotations = ~~($scope.rotate.y / 360)
    angle = $scope.rotate.y % 360
    console.log $route.current.params.page
    switch $route.current.params.page
      when undefined then $scope.rotate.y = 0 + 360*rotations
      when "charts" 
        if (angle > -90) then $scope.rotate.y = 90 + 360*rotations
        else $scope.rotate.y = -270 + 360*rotations
      when "projects"  
        if(angle < 90)
          $scope.rotate.y = -90 + 360*rotations
        else $scope.rotate.y = 270 + 360*rotations
      when "about" 
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

app.controller "chartsCtrl", [ '$scope','socket','$timeout','btcHistory','$filter', ($scope,socket,$timeout,btcHistory,$filter)->

  socket.on 'init', (data)->
    getData()

  $scope.btcData = {};
  $scope.history = [];
  $scope.filtered ={}

  $scope.trim = 100;

  # btcHistory.getHistory (data)->
  #   $scope.history = $filter('btcData')(data);
    # $scope.filtered = $filter('btcAverage')(data);
    # console.log(data)
  getData = ()->
    socket.emit 'getData', $scope.trim, (data) ->
      console.log(data)
      $scope.history = $filter('btcData')(data);

  socket.on 'btc-data', (data)->
    # console.log(JSON.parse(data.data))
    $scope.btcData = $filter('btcData')(JSON.parse(data.data))
    if($scope.history[0])
      $scope.history.push($scope.btcData) 
      # $scope.filtered = $filter('btcAverage')($scope.history);

    # console.log $scope.btcData
]
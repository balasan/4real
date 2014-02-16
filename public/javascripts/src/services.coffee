app =  angular.module("4real.services", [])


app.factory "socket", ($rootScope) ->
  socket = io.connect()
  on: (eventName, callback) ->
    socket.on eventName, ->
      args = arguments
      $rootScope.$apply ->
        # callback args
        callback.apply socket, args
      # $rootScope.$apply()

  emit: (eventName, data, callback) ->
    socket.emit eventName, data, ->
      args = arguments
      $rootScope.$apply ->
        # callback args  if callback
        callback.apply socket, args  if callback


app.factory "btcHistory", [ '$rootScope', '$http', ($rootScope, $http) ->
  getHistory: (callback)->
    $http(
      method: 'GET'
      url: 'https://data.mtgox.com/api/2/BTCUSD/money/trades/fetch'
    ).success( (data, status, headers, config) ->
      # jdata = JSON.parse(data)
      callback(data.data)
    ).error((data, status, headers, config) ->
      console.log('error geting historical data')
    )
]


app.factory 'projectsService', [ ()->

  amazonUrl = "https://s3-us-west-2.amazonaws.com/4real/projects/"

  data = [
    title: 'DIS Images'
    description: ''
    url: 'http://disimages.com'
    img: [
      url: amazonUrl + 'disimages.png'
    ]
    iphone:[]
  ,
    title: 'David Lewis Gallery'
    description: ''
    url: 'http://davidlewisgallery.com'
    img: [
      url: amazonUrl + 'davidlewis.png'
    ]
    iphone:[
      url: amazonUrl+ 'dlphone.png'
    ]
  ,
    title: 'Gifpumper'
    description: 'realtime 3d collage platform'
    url: 'http://gifpumper.com'
    img: [
      url: amazonUrl + 'gifpumper.png'
    ]
    iphone:[]
  ,
    title: 'Walmart at 50'
    description: 'platform for users to upload their walmart stories'
    url: 'http://walmartat50.org'
    img: [
      url: amazonUrl + 'walmart.png'
    ]
    iphone:[]
  ,
    title: 'Timelines'
    description: 'an iPad app that generates a 3d timeline of your life'
    url: ''
    img: [
      url: amazonUrl + 'timelinksipad.png'
    ]
    tablet: [
      url: amazonUrl + 'timelinksipad.png'
    ]
    iphone:[]
  ,
    title: 'Casey Kaplan Gallery'
    description: ''
    url: 'http://caseykaplangallery.com'
    img: [
      url: amazonUrl + 'caseykaplan.png'
    ]
    iphone:[]
  ,
    title: 'The Digit'
    description: 'Augmented Reality App'
    url: 'http://balasan.net/thedigit/'
    img: [
      url: amazonUrl + 'digit.png'
    ]
    iphone:[
      url: amazonUrl + "digitphone2.png"
    ] 

  ]

  projects : data
  

]

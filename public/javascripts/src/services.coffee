app =  angular.module("4real.services", [])


app.factory 'webGL', ($window)->
   
  initWater : ()->
    try
      if !this.waterView
        this.waterView = new window.waterView()
      return this.waterView
    catch error
      return {error:error.message}

app.factory 'isMobile', ($window)->
  return ()->
    if ($window.innerWidth < 800)
      return true
    return false


app.factory "socket", ($rootScope) ->
  socket = io.connect( '/')

  # window.ononbeforeunload = ()->
  #   socket.disconnect()
  #   console.log( 'disconnect')

  # window.onload = ()->
  #   socket.socket.reconnect()
  #   console.log( 'reconnect')

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

app.factory "exchange", ['$rootScope', '$http', ($rootScope, $http) ->
  getRates: (callback)->
    $http(
      method: "GET"
      url: "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%3D%22%20EURUSD%2CRUBUSD%2CGBPUSD%2CJPYUSD%2CCNYUSD%22&format=json&diagnostics=false&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    ).success( (data)->
      callback(data.query)
    ).error(()->
      console.log("error getting exchange rates")
    )
] 

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

app.factory "siteMap", [->
  data =
    main:
      title: "4real Digital Agency"
      description: "4real is a digital agency specializing in designing and building scalable technology-driven websites & apps for the real world. It was started by Slava Balasanov and Analisa Teachworth in 2014. 4real aims to re-envision the web and reformulate communication-interaction channels. The fusion of technological and creative resources lends to the development of agile software and integrated design. Although based in New York, 4real remains a global enterprise, with offices in Moscow, along with designers and programmers team members in London and Berlin."
      keywords: "4real, digital, agency, New York, NYC, Moscow, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg:'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'

    about:
      title: "4real - About"
      description: "4real agency offers consultancy and expertise with a keen sense of global culture. 4REAL creates online experiences that span a variety of digital environments, including video, mobile, 3D, sound, and modular. The traditional gaps between user and brand, art and consumption, culture and commerce - these are spaces where technology can create wholly new cultural experiences for users. 4REAL creates integrated online systems, across an array of digital platforms, that facilitate a deeper two-way exchange between brands and consumers."
      keywords: "4real, digital, agency, about, information, NYC, Moscow, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg:'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'

    charts:
      title: "4real - Analytics"
      description: "At 4real studio we think realtime technology is becoming ever-more important.           The 'Analytics Section' illustrates a realtime bitcoin feed from the Bitstam exchange.           The chart is using Bitstamp API and D3"
      keywords: "4real, digital, agency, analytics, charts, bitcoin, bitstamp, realtime, prices, currency, NYC, Moscow, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg:'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'

    projects:
      title: "4real - Projects"
      description: "These are some of the projects we have worked on. We like to fucus on projects that are culturally relevant and provide an opportunity to create a new and exciting interaction."
      keywords: "4real, projects, digital, agency, projects, galleries, DISImages, Dismagazine, NYC, Moscow, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg:'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'

    liquid:
      title: "4real - Liquid Demo"
      description: "4real demo of liquid dynamics. This demo is done in WebGL using GLSL shader language to crete an interactive, realtime visualisation of liquid."
      keywords: "4real, digital, agency, interactive, demo, water, Webgl, liquid, information, NYC, Moscow, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg: "https://s3-us-west-2.amazonaws.com/4real/various/liquid.png"
]

app.factory 'projectsService', [ ()->

  amazonUrl = "https://s3-us-west-2.amazonaws.com/4real/projects/"

  data = [
    title: 'DIS Images'
    description: ''
    url: 'http://disimages.com'
    img: [
      url: amazonUrl + 'disimages.jpg'
    ]
    iphone:[]
  ,
    title: 'Gifpumper'
    description: 'realtime 3d collage platform'
    url: 'http://gifpumper.com'
    img: [
      url: amazonUrl + 'gifpumper.jpg'
    ]
    iphone:[]
  ,
    title: 'Kehinde Wiley Studio'
    description: 'website for artist Kehinde Wiley'
    url: 'http://kehindewiley.com'
    img: [
      url: amazonUrl + 'kehindewiley.jpg'
    ]
    iphone:[
      url: amazonUrl+ 'kwphone.png'
    ]
  ,
    title: 'TWAAS'
    description: 'Website for Thea Westreich art advisory services'
    url: 'http://twaas.com ' 
    img: [
      url: amazonUrl + 'twaas.jpg'
    ]
    tablet: [
      
    ]
    iphone:[
      url: amazonUrl + 'twaasphone.png'
    ]
  ,

    title: 'Walmart at 50'
    description: 'platform for users to upload their walmart stories'
    url: 'http://walmartat50.org'
    img: [
      url: amazonUrl + 'walmart.jpg'
    ]
    iphone:[]
  ,

    title: 'David Lewis Gallery'
    description: ''
    url: 'http://davidlewisgallery.com'
    img: [
      url: amazonUrl + 'davidlewis.jpg'
    ]
    iphone:[
      url: amazonUrl+ 'dlphone.png'
    ]

  ,

  #   title: 'Casey Kaplan Gallery'
  #   description: ''
  #   url: 'http://caseykaplangallery.com'
  #   img: [
  #     url: amazonUrl + 'caseykaplan.png'
  #   ]
  #   iphone:[]
  # ,
    title: 'The Digit'
    description: 'Augmented Reality App'
    url: 'http://balasan.net/thedigit/'
    img: [
      url: amazonUrl + 'digit.jpg'
    ]
    iphone:[
      url: amazonUrl + "digitphone2.png"
    ] 

  ]

  projects : data
  

]

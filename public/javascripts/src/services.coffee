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
    if ($window.innerWidth < 700)
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
      url: "https://data.fixer.io/api/latest?base=USD&symbols=CEUR,CGBP,CRUB,CJPY,CCNY"
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
      description: "4real is a digital agency specializing in designing and building scalable technology-driven websites & apps for the real world. It was started by Slava Balasanov and Analisa Teachworth in 2014. 4real aims to re-envision the web and reformulate communication-interaction channels. The fusion of technological and creative resources lends to the development of agile software and integrated design."
      keywords: "4real, digital, agency, New York, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg:'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'

    about:
      title: "4real - About"
      description: "4real agency offers consultancy and expertise with a keen sense of global culture. 4REAL creates online experiences that span a variety of digital environments, including video, mobile, 3D, sound, and modular. The traditional gaps between user and brand, art and consumption, culture and commerce - these are spaces where technology can create wholly new cultural experiences for users. 4REAL creates integrated online systems, across an array of digital platforms, that facilitate a deeper two-way exchange between brands and consumers."
      keywords: "4real, digital, agency, about, information, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg:'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'

    charts:
      title: "4real - Analytics"
      description: "At 4real studio we think realtime technology is becoming ever-more important.           The 'Analytics Section' illustrates a realtime bitcoin feed from the Bitstam exchange.           The chart is using Bitstamp API and D3"
      keywords: "4real, digital, agency, analytics, charts, bitcoin, bitstamp, realtime, prices, currency, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg:'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'

    projects:
      title: "4real - Projects"
      description: "These are some of the projects we have worked on. We like to fucus on projects that are culturally relevant and provide an opportunity to create a new and exciting interaction."
      keywords: "4real, projects, digital, agency, projects, galleries, DISImages, Dismagazine, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg:'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'

    liquid:
      title: "4real - Liquid Demo"
      description: "4real demo of liquid dynamics. This demo is done in WebGL using GLSL shader language to crete an interactive, realtime visualisation of liquid."
      keywords: "4real, digital, agency, interactive, demo, water, Webgl, liquid, information, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth"
      fbimg: "https://s3-us-west-2.amazonaws.com/4real/various/liquid.png"
]

app.factory 'projectsService', [ ()->

  amazonUrl = "https://s3-us-west-2.amazonaws.com/4real/projects/"

  data = [


    title: 'Clinton Global Initiative'
    description: ''
    # url: 'http://cgi-interactive.clintonfoundation.org/'
    url: 'http://cgi-globe.herokuapp.com/'
    img: [
      url: amazonUrl + 'cgi-web.jpg'
    ]
    iphone:[]
  ,

    title: 'Clone Zone'
    description: ''
    url: 'http://clonezone.link'
    img: [
      url: amazonUrl + 'clonezone.jpg'
    ]
    iphone:[
     url: amazonUrl + 'clonezone-phone.png'
    ]
  ,


    title: 'Thermal Online Experience'
    description: ''
    url: 'http://tgf-thermal.herokuapp.com'
    img: [
      url: amazonUrl + 'thermal.jpg'
    ]
    iphone:[]
  ,


    title: 'H0les'
    description: ''
    url: 'http://h0les.com'
    img: [
      url: amazonUrl + 'holes-sm.jpg'
    ]
    iphone:[
     url: amazonUrl + 'holes-phone1.png'
    ]
  ,


    title: 'DIS Magazine Mobile'
    description: ''
    url: 'http://dismagazine.com'
    img: [
      url: amazonUrl + 'dis-web.jpg'
    ]
    iphone:[
     url: amazonUrl + 'dis-phone.png'
    ]
  ,

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
  #   title: 'TWAAS'
  #   description: 'Website for Thea Westreich art advisory services'
  #   url: 'http://twaas.com ' 
  #   img: [
  #     url: amazonUrl + 'twaas.jpg'
  #   ]
  #   tablet: [
      
  #   ]
  #   iphone:[
  #     url: amazonUrl + 'twaasphone.png'
  #   ]
  # ,

  #   title: 'Walmart at 50'
  #   description: 'platform for users to upload their walmart stories'
  #   url: 'http://walmartat50.org'
  #   img: [
  #     url: amazonUrl + 'walmart.jpg'
  #   ]
  #   iphone:[]
  #   ,


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

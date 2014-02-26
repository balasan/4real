
###
Module dependencies.
###
require('newrelic');
express = require("express")
routes = require("./routes")
http = require("http")
https = require("https")


path = require("path")
socket = require('./routes/socket');
# gox = require('goxstream')
db = require('./db')()

app = express()
server = require('http').createServer(app)
io = require('socket.io').listen(server, {log: false});


app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser("your secret here")
  app.use express.session()
  app.use app.router
  app.use require("less-middleware")(
    src: __dirname + "/public"
    )
  app.use express.static(path.join(__dirname, "public"))


app.configure "development", ->
  app.use express.errorHandler()

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")



app.get "/", routes.index
app.get "/partials/:name", routes.partials
app.get "/charts", routes.index
app.get "/projects", routes.index
app.get "/about", routes.index


# btc = gox.createStream({trade:false,ticker:true}) 

# btc.on 'data' , (data)->
  # io.sockets.emit('btc-data', data:data)


setInterval

lastTime = new Date(0)
seconds = 5
the_interval = seconds * 1000

getData = ()->
  url = "https://www.bitstamp.net:443/api/ticker/"
  https.get(url, (res) ->
    body = ""
    res.on "data", (chunk) ->
      body += chunk
      return

    res.on "end", ->
      try
        data = JSON.parse(body)
      catch error
        console.log(body)
        return
      # console.log(data)
      newTime = new Date(parseInt(data.timestamp)*100)
      if  newTime > lastTime
        lastTime = newTime
        io.sockets.emit('btc-data', data:data)

    return
  ).on "error", (e) ->
    console.log "Got error: ", e
    return


getData()

setInterval getData, the_interval




io.sockets.on('connection', (socket)->
  socket.emit('init')
  socket.on('getData', (limit, callback)->

    if !limit
      limit = 1000

    db.secondModel.find().limit(limit).sort(timestamp: -1).limit(limit).exec (err, data) ->
      if err
        console.log err
      else
        callback(data)

    # bitcoinModel.find().limit(limit).sort("data.ticker.now": -1).exec (err, tickers) ->
    #   if err
    #     console.log err
    #   else
    #     # console.log tickers
    #     callback(tickers)
  )
)






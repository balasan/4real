
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
socket = require('./routes/socket');
gox = require('goxstream')
mongoose = require('mongoose')

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


btc = gox.createStream({trade:false,ticker:true}) 

btc.on 'data' , (data)->
  io.sockets.emit('btc-data', data:data)

io.sockets.on('connection', (socket)->
  socket.emit('init')
  socket.on('getData', (limit, callback)->

    if !limit
      limit = 1000
    bitcoinModel.find().limit(limit).sort("data.ticker.now": -1).exec (err, tickers) ->
      if err
        console.log err
      else
        # console.log tickers
        callback(tickers)
  )
)

mongoose.connect "mongodb://" + process.env.MONGODB_USERNAME + ":" + process.env.MONGODB_PASSWORD + "@ds027729.mongolab.com:27729/bitcoin"
Schema = mongoose.Schema
bitcoinSchema = new Schema(
  data: Schema.Types.Mixed
,
  capped:
    size: 268435456

  strict: false
  toJSON: true
)
bitcoinModel = mongoose.model("bitcoinModel", bitcoinSchema)







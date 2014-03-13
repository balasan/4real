module.exports = (db) ->
  
  http = require('http')
  rateData = {}
  getRates = ()->
    url="http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%3D%22%20EURUSD%2CRUBUSD%2CGBPUSD%2CJPYUSD%2CCNYUSD%22&format=json&diagnostics=false&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    http.get(url, (res) ->
      body = ""
      res.on "data", (chunk) ->
        body += chunk
        return
      res.on "end", ->
        try
          rateData = JSON.parse(body).query.results.rate
          # console.log(rateData)
        catch error
          setTimeout getRates, 5 * 60 * 1000
          console.log "error getting rates" + error
          return
      return
    ).on "error", (e) ->
      console.log "Got error: ", e
      return

  getRates()
  setInterval getRates, 1000 * 60 * 60 * 4

  rates: rateData


  index : (req, res) ->
    limit = 60

    db.secondModel.find().sort(timestamp: -1).limit(limit).exec (err, data) ->
      if err
        console.log err
      else
        # console.log data
        # console.log rateData
        res.render('index',  
          title: '4REAL' 
          data: data,
          rates: rateData
          );
    
    # res.render('index',  
    #   title: '4REAL' 
    #   data: {}
    #   rates: {}
    #   );

  partials : (req, res) ->  
    name = req.params.name;
    res.render('partials/' + name);

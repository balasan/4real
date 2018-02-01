module.exports = (db) ->
  
  http = require('http')
  https = require('https')
  rateData = {}
  getRates = ()->
    url="https://api.fixer.io/latest?base=USD&symbols=CEUR,CGBP,CRUB,CJPY,CCNY"
    https.get(url, (res) ->
      body = ""
      res.on "data", (chunk) ->
        body += chunk
        return
      res.on "end", ->
        try
          console.log(JSON.parse(body))
          rateData = JSON.parse(body).rates
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


  liquid : (req,res) ->
    res.render('liquid')


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

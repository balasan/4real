app =  angular.module("4real.filters", [])

app.filter "ticker", ["$sce", ($sce)->
  (data, cur) ->
    if(data)
        # $sce.trustAsHtml('<i class="fa fa-'+cur+'"></i> '+parseFloat(data).toFixed(2))
       parseFloat(data).toFixed(2)

]

app.filter "btcData", [ ()->
  (data)->
    if(data[0])
      data.reverse()
      data.forEach (d) ->
        d.price = parseFloat(d.last)
        d.date = new Date(d.timestamp)
    else
        data.price = parseFloat(data.last)
        data.date = new Date(parseInt(data.timestamp)*1000)
    data
]


app.filter "prefix", [ ()->
  styles = window.getComputedStyle(document.documentElement, "")
  pre = (Array::slice.call(styles).join("").match(/-(moz|webkit|ms)-/) or (styles.OLink is "" and ["", "o"]))[1]
  dom = ("WebKit|Moz|MS|O").match(new RegExp("(" + pre + ")", "i"))[1]
  dom: dom
  lowercase: pre
  css: "-" + pre + "-"
  js: pre[0].toUpperCase() + pre.substr(1)
]

# app.filter "btcAverage", [ ()->
#   (data, interval)->
#     filtered=[] 
#     intStart = intEnd = sum = elCount  = null;
#     index = -1;
#     data.forEach (d) ->
#       d.price = parseFloat(d.price)
#       d.date = new Date(d.date*1000)
#       if(!intStart || d.date.getTime > intEnd)
#         elCount = 1
#         intStart = d.date.getTime()
#         intEnd = d.date.getTime(interval*60*1000)
#         sum = d.price
#         index++
#       else
#         avg = avg*elCount/elCount++
#         elCont++
#         filtered[new Date(intEnd)].price = avg
#     filtered

# ]

app.filter "btcTrim", [ ()->
  (data,trim)->
    trimmed = data.slice(Math.max(data.length - trim, 1))
    trimmed
]
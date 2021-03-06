app =  angular.module("4real.directives", [])


# app.directive "bgcolor", [ ()->
#   scope: false
#   link: (scope, el, att) ->
#     bgColorList=new Array("rgba(143,188,143,.75)", "rgba(102,204,255,.75)", "rgba(194,127,255,.75)", "rgba(200,105,221,.75)", "rgba(255,0,170,.75)", "rgba(90,215,240,.75)", "rgba(112,219,147,.75)")

#     r = Math.random(0,1)
#     color = bgColorList[Math.floor(r*bgColorList.length)]
#     el.css
#       "background-color" : color
# ]

app.directive "title", ["$timeout", "$window", ($timeout, $window) ->
  link: (scope, el, attr) ->
    $timeout ()->
      el.html scope.title
] 


app.directive "loaded", ["$timeout", "$window", ($timeout, $window) ->
  link: (scope, el, attr) ->
    el.on 'load', ()->
      scope.loadedImg +=1
      scope.$apply()
]

app.directive "liquid", ["$timeout", "$window","isMobile","webGL", ($timeout, $window,isMobile,webGL) ->

  link: (scope, el, attr) ->
    canvas = angular.element(document.getElementById('waterCanvas'))
    canvas.addClass('visible')
    scope.water = webGL.initWater()
    if scope.water.error 
      html = scope.water.error 
      if html == 'WebGL not supported'
        if(isMobile())    
          error = document.getElementById('errorMobile');
        else 
          error = document.getElementById('error');
        angular.element(error).css
          display: 'block'
    else
      scope.water.paused=false;
      scope.water.animate();
      scope.$watch 'loadedImg', (newV,oldV)->
        if newV == 6
          scope.water.skyReady = true;
          scope.water.renderCubemap()      
    scope.$on '$destroy', ()->
       scope.water.paused = true
       # canvas.remove();
       canvas.removeClass('visible')

]

app.directive "video", ["$timeout", "$window","isMobile", ($timeout, $window, isMobile) ->
  link: (scope, el, attr) ->
    vidHeight = 0;
    vidWidth = 0;
    resize = () ->
      viewportWidth = $window.innerWidth
      viewportHeight = $window.innerHeight
      #assume all videos are the same width height
      if vidWidth / vidHeight > viewportWidth / viewportHeight
        el.css
          height: viewportHeight
        vidHeight = el.offsetHeight
        el.css
          'width':"auto"
        vidWidth = el[0].offsetWidth
      else
        el.css
          width: viewportWidth
        vidWidth = el.offsetWidth
        el.css
          height : 'auto'
        vidHeight = el[0].offsetHeight
      if vidWidth > viewportWidth
        adjust = -1 / 2 * (vidWidth - viewportWidth)
        el.css
          "margin-left": adjust
          "margin-top": 0
      else
        adjust = -1 / 2 * (vidHeight - viewportHeight)
        el.css
          "margin-top": adjust
          "margin-left": 0

    el.on 'loadedmetadata', () ->
      vidHeight = el[0].offsetHeight
      vidWidth = el[0].offsetWidth
      resize();

    el.on 'ended', ()->
      scope.playNextVideo()



    scope.$watch 'activeVideo', (newV, oldV) ->
        if isMobile() 
          return;

      # if newV != oldV
        if scope.videos[scope.activeVideo] == el[0].id
          if(el[0].play)
            el[0].play()
          el.addClass('activeVid')
        else
          if(el[0].pause)
            el[0].pause()
          if el[0].currentTime
            el[0].currentTime = 0;
          el.removeClass('activeVid')

    angular.element($window).bind 'resize', ->
      vidHeight = el[0].offsetHeight
      vidWidth = el[0].offsetWidth
      resize()
    # $timeout ()->



]

app.directive "date", ["$filter",'$timeout','isMobile', ($filter,$timeout,isMobile)->
  scope: true
  link: (scope, el, attr)->
    
    update = ()->
      now = moment()
      moment.lang 'en'
      scope.year = now.format('YYYY')
      scope.date = now.format('D')
      scope.day = now.format('ddd')
      scope.time = now.format('h:mm:ss')
      scope.month = now.format('MMM')

    timedUpdate = ->
      update()
      $timeout timedUpdate, 1000
      return
    # if (!isMobile)
    timedUpdate()
]

app.directive "clock", ["$filter",'$timeout','isMobile', ($filter,$timeout, isMobile)->
  scope: 
    location: "@"
  templateUrl: "/partials/clock"
  link: (scope, el, attr)->

    if(isMobile())
      return

    update = ->
      moment = window.moment
      # moment.lang attr.language
      
      # $("#js-format").html formatHtml()
      # $("#js-from-now").html fromHtml()
      # $("#js-calendar").html calendarHtml()
      # $("#js-lang").html langHtml()
      prefix = $filter('prefix')

      now = moment().tz(attr.timezone)
      second = now.seconds() * 6
      minute = now.minutes() * 6 + second / 60
      hour = ((now.hours() % 12) / 12) * 360 + 90 + minute / 12
      obj = {}
      obj[prefix.css+ "transform"] = "rotate(" + hour + "deg)"
      angular.element(el[0].querySelector('#hour')).css obj
      obj[prefix.css+ "transform"] = "rotate(" + minute + "deg)"
      angular.element(el[0].querySelector('#minute')).css obj
      obj[prefix.css+ "transform"] = "rotate(" + second + "deg)"
      angular.element(el[0].querySelector('#second')).css obj
      # scope.year = now.format('YYYY')
      # scope.date = now.format('D')
      # scope.day = now.format('ddd')
      # scope.time = now.format('h:mm:ss')
      # scope.month = now.format('MMM')
      scope.ampm = now.format('a')

      return
    timedUpdate = ->
      update()
      $timeout timedUpdate, 1000
      return
    timedUpdate()

]

app.directive "abouts", ['$timeout','$window', ($timeout, $window)->
  link : (scope, el, attr) ->
    
    resize = ()->
      wh = 
        $window.innerHeight
      el.css
        height:'auto'
      height = el[0].offsetHeight
      if height < wh
        el.css
          height:height
          'margin-top': -height/2
          top:wh*.9/2
    resize()
    angular.element($window).bind 'resize', resize

]

app.directive "about", ['$timeout', ($timeout)->
  link : (scope, el, attr) ->

    lineIndex = 0
    position = 0
    text = ""
    cursor = "<span class='cursor'>|</span>"

    newLine = ()->
      text = ""
      if(scope.text[lineIndex])
        printLine(scope.text[lineIndex])
    
    printLine = (line)->
      position=0
      appendLetter( line, line[position] )

    appendLetter = (line, l) ->
      text += line[position]
      el.html( text + cursor)
      position++
      if position < line.length
        $timeout( ()->
          appendLetter(line, line[position])
        ,40 + Math.random() * 20)
      else 
        lineIndex++
        $timeout( ()->
          newLine()
        ,2000)

    $timeout(newLine,100)
]

app.directive "glass", ['$window', '$timeout','$filter', ($window, $timeout,$filter)->
  link: (scope, el, att) ->
    prefix = $filter('prefix')
    resize = ()->
      width = $window.innerWidth
      if el.hasClass('left')
        obj = {}
        transform = "translateX("+width+"px) rotateY(90deg)"
        el.css
          transform : transform
          '-webkit-transform' : transform
          
      else if el.hasClass('right')
        obj = {}
        transform = "translateX("+-width+"px) rotateY(-90deg)"
        el.css(
          transform : transform
          '-webkit-transform' : transform
          )
      else if el.hasClass('back')
        obj = {}
        transform = " translateZ("+ (-width)+"px) rotateY(-180deg)"
        el.css(
          transform : transform
          '-webkit-transform' : transform
          )
    resize()
    angular.element($window).bind 'resize', ->
      resize()
]

app.directive "cube", [ '$document', '$window', '$timeout', '$state', "isMobile", ($document, $window,$timeout,$state,isMobile)->
  link: (scope, el, att) ->
    scope.oldH = 0;
    scope.oldV = 0;
    scope.newH = 0;
    scope.newV = 0;
    scope.oldR = 0;
    scope.newR = scope.rotate.y
    scope.dragX = 0;

    rotateScene = (e) ->
      scope.newH  = .5 - (e.pageX / $window.innerWidth)
      scope.newV = -.5 + (e.pageY / $window.innerHeight)

    specular = el.find("specular")

    # specular.on 'pointerdown', (e)->
    #   $this = angular.element(this)
    #   $this.css 
    #     'display':'none'

    #   underneathElem = document.elementFromPoint(e.x, e.y);

    #   $this.css 
    #     'display':'block'

    #   e.target = underneathElem;
    #   underneathElem.dispatchEvent(e);

    last = new Date()

    updateRotation = () ->

      now = new Date()
      elapsed = now - last
      last = now
      # assune 60fps

      dr = scope.rotate.y + scope.dragX - scope.oldR
      if Math.abs(dr)>.1 then dr *=.1 
      # * elapsed/25
      scope.oldR += dr

      inc = 0.05
      if scope.mode == "auto"
        inc = .04

      dx = scope.newH - scope.oldH 
      dy = scope.newV - scope.oldV
      if Math.abs(dx)>.001 then dx *=inc
      if Math.abs(dy)>.001 then dy *=inc
      scope.oldH += dx
      scope.oldV += dy

      if (scope.oldV ==0)
        scope.odV = .0001;
      if (scope.oldH ==0)
        scope.odH = .0001;

      transform= " translateZ("+ -$window.innerWidth/2+"px) rotateX(" + ((scope.oldV * 5)) + "deg) rotateY(" + ((scope.oldH * 5) + scope.oldR) + "deg) translateZ("+ $window.innerWidth/2+"px)"

      # transform= "rotateX(" + ((scope.oldV * 5)) + "deg) rotateY(" + ((scope.oldH * 5) + scope.oldR) + "deg) "
      el.css 
        "transform": transform
        "-moz-transform": transform
        "-ms-transform": transform
        "-webkit-transform": transform
      offset = 0
      # if isMobile()
        # offset = -400

      if !isMobile() 
        transform2="translateX("+((scope.oldH * -400)) + "px ) translateY("+(-scope.oldV * 400  + offset) + "px) translateZ(0)"
        

        Array.prototype.slice.apply(specular).forEach (spec)->
          specEl = angular.element(spec)
          if specEl.hasClass('active')
            specEl.css
              # "background-position": (-200 + (scope.oldH * -500)) + "px " + (-scope.oldV * 600) + "px"
              "transform": transform2
              "-moz-transform": transform2
              "-ms-transform": transform2
              "-webkit-transform": transform2
              # "background-position": (-200 + (scope.oldH * -500)) + "px " + (-scope.oldV * 600 -200 + offset) + "px"
              # opacity: 1 - (scope.oldH * .45) - (scope.oldV * .45)

      transform = "rotateX(" + (65 + (scope.oldV * 20)) + "deg) rotateY(" + (10 - (scope.oldH * 20)) + "deg) skewX(-15deg)"
      # el.find("shadow").css 
      #   "-webkit-transform": transform
      #   "-moz-transform": transform
      #   "-ms-transform": transform
      #   "transform": transform

      if isMobile() 
        $timeout(updateRotation, 20)
      else
        window.requestAnimationFrame(updateRotation,30);

    resize = ()->
      scope.windowWidth = $window.innerWidth

      el.css
        # 'transform-origin': '50% 50% '+ -scope.windowWidth/2+'px'
        # '-webkit-transform-origin': '50% 50% '+ -scope.windowWidth/2+'px'


    resize()
    
    $document.on('mousemove', rotateScene)
    
    scale = 250
    w = angular.element($window)


 

    $arrowLeft = angular.element(el[0].getElementsByClassName('leftArrow'))
    $arrowRight = angular.element(el[0].getElementsByClassName('rightArrow'))
    
    $arrowLeft.on('click',  ()->
      scope.rotate.y+=90
    )
  
    $arrowRight.on('click', ()->
      scope.rotate.y-=90
    )

    cleanup = ()->
      if scope.page == 'liquid'
        return;
      w.unbind 'pointermove'
      scope.rotate.y += Math.round(scope.dragX / 90) * 90;
      scope.dragX = 0
      angle = scope.rotate.y % 360 
      switch angle
        when 0 then page = ''
        when 90 then page= 'charts'
        when -90 then page = 'projects'
        when 180 then page = 'about'
        when 270 then page = 'projects'
        when -270 then page = 'charts'
        when -180 then page = 'about'
      if page==""
        state = 'index'
      else
        state = 'index.'+page
      $state.go(state)
      el.removeClass('grab')


    auto = ()->
      scope.rotate.y += 90;
      cleanup()
      t = Math.random()
      $timeout auto, 40000 * t

    randomVertical = () ->
      v = Math.random()
      h = Math.random()
      scope.newV = (v-.5)*1.5
      scope.newH = (h-.5)*2
      $timeout randomVertical, 6000*v
    
    scope.$watch 'page', ()->
      if scope.page == 'auto'
        scope.rotate.y = -90;
        cleanup()
        randomVertical()
        auto()
        scope.mode = 'auto';

    el.bind 'pointerdown', (e)->
      el.addClass('grab')
      startX = e.x 
      startY = e.y
      w.bind 'pointermove', (e)->
        # e.maskedEvent.preventDefault()
        scope.dragX = ((e.x - startX)/scope.windowWidth)*scale
        # e.maskedEvent.stopPropagation();
    w.bind 'pointerup', (e) ->
      cleanup()

    w.bind 'resize', ->
      resize()

    document.addEventListener 'mouseout',(e) ->
      e = (if e then e else window.event)
      from = e.relatedTarget or e.toElement
      if not from or from.nodeName is "HTML"
        e.preventDefault()
        cleanup() 
      return

    updateRotation()
]

app.directive "graph", [ '$window', '$filter','isMobile', ($window, $filter, isMobile)->
  link: (scope, el, att) ->

    animate = true
    if isMobile() 
      animate = false

    data = $filter('btcTrim')(scope.history,scope.trim)

    parseDate = d3.time.format("%b %Y").parse;

    margin = [30, 30, 50, 60]
    width = Math.max($window.innerWidth*.5, 300) - margin[1] - margin[3]
    height = Math.max($window.innerHeight*.5, 300)- margin[0] - margin[2]

    if(isMobile())
      height = width * 1.7/3



    svg = d3.select("#chart").append("svg")
      .attr("viewBox","0 0 " + (width + margin[3] + margin[1])+" "+(height + margin[0] + margin[2]))
      .attr("preserveAspectRatio","xMidYMid")
      .attr("width", width + margin[3] + margin[1])
      .attr("height", height + margin[0] + margin[2])
      .append("svg:g")
      .attr("transform", "translate(" + margin[3] + "," + margin[0] + ")");

    ticks = 5
    if isMobile()
      ticks = 3

    x = d3.time.scale().range([0, width])
    y = d3.scale.linear().range([height, 0])
    xAxis = d3.svg.axis().scale(x).orient("bottom")
      .tickSize(3)
      .tickPadding(3)
      .ticks(ticks)
      # .scale.ticks(5)
    yAxis = d3.svg.axis().scale(y).orient("left")
      .tickSize(3)
      .tickPadding(3)
      .ticks(ticks)
      .tickFormat(d3.format("$,f"))


    tooltip = d3.select('body').append('div')
      .attr('class', 'tooltip')
      .style('opacity', 0);

    # line = d3.svg.line()
    #   .x (d) ->
    #     x(d.date)
    #   .y (d)->
    #     y(d.price)

    movingWindowAvg = (arr, step) -> # Window size = 2 * step + 1
      arr.map (_, idx) ->
        wnd = arr.slice(idx - step, idx + step + 1)
        result = d3.sum(wnd) / wnd.length
        result = _  if isNaN(result)
        result



    line = (data, k) ->
      data = data.map((d, i) ->
        if i > k
          [k, data[k]]
        else
          [i, d]
      )
      d3.svg.line().interpolate("monotone")
      .x((d) ->
        x d[1].date
      ).y((d) ->
        y d[1].price
      ) data

    area = (data, k) ->
      data = data.map((d, i) ->
        if i > k
          [k, data[k]]
        else
          [i, d]
      )
      d3.svg.area().interpolate("monotone")
        .x((d) ->
          x d[1].date
        )
        .y0(height)
        .y1((d) ->
          y d[1].price
        ) data


    x.domain d3.extent data.map (d) ->
      d.date
    maximum = d3.max data.map (d) ->
      d.price
    minimum = d3.min data.map (d) ->
      d.price
    y.domain [parseInt(minimum) - 5, parseInt(maximum) + 5]

    gradient = svg.append("svg:defs")
      .append("svg:linearGradient")
      .attr("id", "gradient")
      .attr("x2", "0%")
      .attr("y2", "100%")
    gradient.append("svg:stop")
      .attr("offset", "0%")
      .attr("stop-color", "#fff")
      .attr "stop-opacity", .2
    gradient.append("svg:stop")
      .attr("offset", "100%")
        .attr("stop-color", "#fff")
        .attr "stop-opacity", 0.0


    # path = svg.append("g")
    #   .attr("clip-path", "url(#clip)")
    #   .append("path")

    roll = (path, k, lineRoll) ->
      # if !animate
        # k = data.length - 1
      if lineRoll
        if k < data.length
          path.transition().duration(1).ease("linear").attr("d", line(data, k)).each "end", ->
            roll path, k + 1, true  
      else  
        if k < data.length
          path.transition().duration(1).ease("linear").attr("d", area(data, k)).each "end", ->
            roll path, k + 1

    path2=svg.append("path")
      .style("fill", "none")

    path=svg.append("path")
      .attr("class", "area")
      .attr("clip-path", "url(#clip)")
      .style("fill", "url(#gradient)")
      .style("stroke",'none')



    gx = svg.append("svg:g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
    gy = svg.append("svg:g").attr("class", "y axis").attr("transform", "translate(0,0)").call yAxis

    # svg.append("defs").append("clipPath")
    #   .attr("id", "clip")
    #   .append("rect")
    #   .attr("width", width)
    #   .attr("height", height);

    resize =()->
      width = Math.max($window.innerWidth*.5, 300) - margin[1] - margin[3]
      height = Math.max($window.innerHeight*.5, 300)- margin[0] - margin[2]

      svg
        .attr("width", width + margin[3] + margin[1])
        .attr("height", height + margin[0] + margin[2])
        .attr("transform", "translate(" + margin[3] + "," + margin[0] + ")");


    updateChart = (redraw)->
      data = $filter('btcTrim')(scope.history,scope.trim)
      # data = movingWindowAvg($filter('btcTrim')(scope.history,scope.trim), 7)

      x.domain d3.extent data.map (d) ->
        d.date
      maximum = d3.max data.map (d) ->
        d.price
      minimum = d3.min data.map (d) ->
        d.price



      y.domain [minimum - 4, maximum + 4]

      gx.call(xAxis);
      gy.call(yAxis);

      
      # only first time
      if animate
        if redraw
          path.attr("d", area(data,0)).transition()
            .attr("clip-path", "url(#clip)")
          path2.attr("d", line(data,0)).transition()
          roll(path2,0,true)
          roll(path,0)
        else 
          path.datum(data).transition()
            .attr("clip-path", "url(#clip)")
            .attr("d", area(data,data.lenght-1))
          path2.datum(data).transition()
            .attr("d", line(data,data.lenght-1)) 
          # roll(path,data.length)
      else
          path.datum(data)
            .attr("clip-path", "url(#clip)")
            .attr("d", area(data,data.lenght-1))
          path2.datum(data)
            .attr("d", line(data,data.lenght-1)) 



      
      # circle = svg.selectAll("circle").data(data)

      # # Add new circle
      # circle.transition()
      # .attr("cx", (d) -> 
      #   x(d.date)
      # ).attr("cy", (d) ->
      #   y(d.price)
      # )

      # circle.enter().append("circle")
      # .attr("r", 3)
      # .attr("cx", (d) ->
      #   cx = x(d.date)
      # ).attr("cy", (d) ->
      #   y(d.price)
      # ).on("mouseover", (d) ->
      #   tooltip.transition().duration(200).style "opacity", 0.9
      #   tooltip.html('$'+(d.price).toFixed(2)).style("left", (d3.event.pageX - 20) + "px").style "top", (d3.event.pageY - 28) + "px"
      # ).on("mouseout", (d) ->
      #   tooltip.transition().duration(500).style "opacity", 0
      # )
      # circle.exit().remove();

    updateChart(true)

    scope.$watch 'history.length', (newV, oldV) ->
      if newV != oldV
        redraw = false;
        if(Math.abs(newV-oldV)>5)
          redraw = true;
        updateChart(redraw)
    
    scope.$watch 'trim', (newV, oldV) ->
      if newV != oldV
        updateChart()

    angular.element($window).bind 'resize', resize

]



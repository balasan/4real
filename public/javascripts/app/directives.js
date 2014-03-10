// Generated by CoffeeScript 1.3.3
(function() {
  var app;

  app = angular.module("4real.directives", []);

  app.directive("video", [
    "$timeout", "$window", function($timeout, $window) {
      return {
        link: function(scope, el, attr) {
          return scope.$watch('page', function(newV, oldV) {
            return $timeout(function() {
              if (newV !== oldV) {
                if (scope.page === 'liquid') {
                  if (!scope.waterView) {
                    scope.waterView = new waterView();
                    scope.waterView.paused = false;
                    scope.activeVideo = -1;
                  }
                  document.getElementById('cube').style.display = "none";
                  document.getElementById('waterCanvas').style.display = "block";
                  return window.paused = false;
                } else {
                  if (scope.waterView) {
                    scope.waterView.paused = true;
                  }
                  document.getElementById('cube').style.display = "block";
                  return document.getElementById('waterCanvas').style.display = "none";
                }
              }
            });
          });
        }
      };
    }
  ]);

  app.directive("video", [
    "$timeout", "$window", function($timeout, $window) {
      return {
        link: function(scope, el, attr) {
          var resize, vidHeight, vidWidth;
          vidHeight = 0;
          vidWidth = 0;
          resize = function() {
            var adjust, viewportHeight, viewportWidth;
            viewportWidth = $window.innerWidth;
            viewportHeight = $window.innerHeight;
            if (vidWidth / vidHeight > viewportWidth / viewportHeight) {
              el.css({
                height: viewportHeight
              });
              vidHeight = el.offsetHeight;
              el.css({
                'width': "auto"
              });
              vidWidth = el[0].offsetWidth;
            } else {
              el.css({
                width: viewportWidth
              });
              vidWidth = el.offsetWidth;
              el.css({
                height: 'auto'
              });
              vidHeight = el[0].offsetHeight;
            }
            if (vidWidth > viewportWidth) {
              adjust = -1 / 2 * (vidWidth - viewportWidth);
              return el.css({
                "margin-left": adjust,
                "margin-top": 0
              });
            } else {
              adjust = -1 / 2 * (vidHeight - viewportHeight);
              return el.css({
                "margin-top": adjust,
                "margin-left": 0
              });
            }
          };
          el.on('loadedmetadata', function() {
            vidHeight = el[0].offsetHeight;
            vidWidth = el[0].offsetWidth;
            return resize();
          });
          el.on('ended', function() {
            return scope.playNextVideo();
          });
          scope.$watch('activeVideo', function(newV, oldV) {
            if (scope.videos[scope.activeVideo] === el[0].id) {
              el[0].play();
              return el.addClass('activeVid');
            } else {
              el[0].pause();
              if (el[0].currentTime) {
                el[0].currentTime = 0;
              }
              return el.removeClass('activeVid');
            }
          });
          return angular.element($window).bind('resize', function() {
            vidHeight = el[0].offsetHeight;
            vidWidth = el[0].offsetWidth;
            return resize();
          });
        }
      };
    }
  ]);

  app.directive("date", [
    "$filter", '$timeout', 'isMobile', function($filter, $timeout, isMobile) {
      return {
        scope: true,
        link: function(scope, el, attr) {
          var timedUpdate, update;
          update = function() {
            var now;
            now = moment();
            moment.lang('en');
            scope.year = now.format('YYYY');
            scope.date = now.format('D');
            scope.day = now.format('ddd');
            scope.time = now.format('h:mm:ss');
            return scope.month = now.format('MMM');
          };
          timedUpdate = function() {
            update();
            $timeout(timedUpdate, 1000);
          };
          return timedUpdate();
        }
      };
    }
  ]);

  app.directive("clock", [
    "$filter", '$timeout', 'isMobile', function($filter, $timeout, isMobile) {
      return {
        scope: {
          location: "@"
        },
        templateUrl: "/partials/clock",
        link: function(scope, el, attr) {
          var timedUpdate, update;
          if (isMobile()) {
            return;
          }
          update = function() {
            var hour, minute, moment, now, obj, prefix, second;
            moment = window.moment;
            prefix = $filter('prefix');
            now = moment().tz(attr.timezone);
            second = now.seconds() * 6;
            minute = now.minutes() * 6 + second / 60;
            hour = ((now.hours() % 12) / 12) * 360 + 90 + minute / 12;
            obj = {};
            obj[prefix.css + "transform"] = "rotate(" + hour + "deg)";
            angular.element(el[0].querySelector('#hour')).css(obj);
            obj[prefix.css + "transform"] = "rotate(" + minute + "deg)";
            angular.element(el[0].querySelector('#minute')).css(obj);
            obj[prefix.css + "transform"] = "rotate(" + second + "deg)";
            angular.element(el[0].querySelector('#second')).css(obj);
            scope.ampm = now.format('a');
          };
          timedUpdate = function() {
            update();
            $timeout(timedUpdate, 1000);
          };
          return timedUpdate();
        }
      };
    }
  ]);

  app.directive("abouts", [
    '$timeout', '$window', function($timeout, $window) {
      return {
        link: function(scope, el, attr) {
          var resize;
          resize = function() {
            var height, wh;
            wh = $window.innerHeight;
            el.css({
              height: 'auto'
            });
            height = el[0].offsetHeight;
            if (height < wh) {
              return el.css({
                height: height,
                'margin-top': -height / 2,
                top: wh * .9 / 2
              });
            }
          };
          resize();
          return angular.element($window).bind('resize', resize);
        }
      };
    }
  ]);

  app.directive("about", [
    '$timeout', function($timeout) {
      return {
        link: function(scope, el, attr) {
          var appendLetter, cursor, lineIndex, newLine, position, printLine, text;
          lineIndex = 0;
          position = 0;
          text = "";
          cursor = "<span class='cursor'>|</span>";
          newLine = function() {
            text = "";
            if (scope.text[lineIndex]) {
              return printLine(scope.text[lineIndex]);
            }
          };
          printLine = function(line) {
            position = 0;
            return appendLetter(line, line[position]);
          };
          appendLetter = function(line, l) {
            text += line[position];
            el.html(text + cursor);
            position++;
            if (position < line.length) {
              return $timeout(function() {
                return appendLetter(line, line[position]);
              }, 40 + Math.random() * 20);
            } else {
              lineIndex++;
              return $timeout(function() {
                return newLine();
              }, 2000);
            }
          };
          return $timeout(newLine, 100);
        }
      };
    }
  ]);

  app.directive("glass", [
    '$window', '$timeout', '$filter', function($window, $timeout, $filter) {
      return {
        link: function(scope, el, att) {
          var prefix, resize;
          prefix = $filter('prefix');
          resize = function() {
            var obj, width;
            width = $window.innerWidth;
            if (el.hasClass('left')) {
              obj = {};
              obj[prefix.css + "transform"] = "translateX(" + width + "px) rotateY(90deg)";
              return el.css(obj);
            } else if (el.hasClass('right')) {
              obj = {};
              obj[prefix.css + "transform"] = "translateX(" + -width + "px) rotateY(-90deg)";
              return el.css(obj);
            } else if (el.hasClass('back')) {
              obj = {};
              obj[prefix.css + "transform"] = " translateZ(" + (-width) + "px) rotateY(-180deg)";
              return el.css(obj);
            }
          };
          resize();
          return angular.element($window).bind('resize', function() {
            return resize();
          });
        }
      };
    }
  ]);

  app.directive("cube", [
    '$document', '$window', '$timeout', '$location', "isMobile", function($document, $window, $timeout, $location, isMobile) {
      return {
        link: function(scope, el, att) {
          var auto, cleanup, randomVertical, resize, rotateScene, scale, updateRotation, w;
          scope.oldH = 0;
          scope.oldV = 0;
          scope.newH = 0;
          scope.newV = 0;
          scope.oldR = 0;
          scope.newR = scope.rotate.y;
          scope.dragX = 0;
          rotateScene = function(e) {
            scope.newH = .5 - (e.pageX / $window.innerWidth);
            return scope.newV = -.5 + (e.pageY / $window.innerHeight);
          };
          updateRotation = function() {
            var dr, dx, dy, inc, offset, transform;
            dr = scope.rotate.y + scope.dragX - scope.oldR;
            if (Math.abs(dr) > .1) {
              dr *= .2;
            }
            scope.oldR += dr;
            inc = 0.1;
            if (scope.mode === "auto") {
              inc = .04;
            }
            dx = scope.newH - scope.oldH;
            dy = scope.newV - scope.oldV;
            if (Math.abs(dx) > .001) {
              dx *= inc;
            }
            if (Math.abs(dy) > .001) {
              dy *= inc;
            }
            scope.oldH += dx;
            scope.oldV += dy;
            transform = "translateZ(" + -scope.windowWidth / 2 + "px) rotateX(" + (scope.oldV * 5) + "deg) rotateY(" + ((scope.oldH * 5) + scope.oldR) + "deg) translateZ(" + scope.windowWidth / 2 + "px) ";
            el.css({
              "transform": transform,
              "-moz-transform": transform,
              "-ms-transform": transform,
              "-webkit-transform": transform
            });
            offset = 0;
            if (isMobile()) {
              offset = -400;
            }
            el.find("specular").css({
              "background-position": (-200 + (scope.oldH * -500)) + "px " + (-scope.oldV * 600 + 1000 + offset) + "px",
              opacity: 1 - (scope.oldH * .45) - (scope.oldV * .45)
            });
            transform = "rotateX(" + (65 + (scope.oldV * 20)) + "deg) rotateY(" + (10 - (scope.oldH * 20)) + "deg) skewX(-15deg)";
            el.find("shadow").css({
              "-webkit-transform": transform,
              "-moz-transform": transform,
              "-ms-transform": transform,
              "transform": transform
            });
            return $timeout(updateRotation, 30);
          };
          resize = function() {
            return scope.windowWidth = $window.innerWidth;
          };
          resize();
          $document.on('mousemove', rotateScene);
          scale = 250;
          w = angular.element($window);
          cleanup = function() {
            var angle;
            if (scope.page === 'liquid') {
              return;
            }
            w.unbind('pointermove');
            scope.rotate.y += Math.round(scope.dragX / 90) * 90;
            scope.dragX = 0;
            angle = scope.rotate.y % 360;
            switch (angle) {
              case 0:
                scope.page = '';
                break;
              case 90:
                scope.page = 'charts';
                break;
              case -90:
                scope.page = 'projects';
                break;
              case 180:
                scope.page = 'about';
                break;
              case 270:
                scope.page = 'projects';
                break;
              case -270:
                scope.page = 'charts';
                break;
              case -180:
                scope.page = 'about';
            }
            return $location.path('/' + scope.page);
          };
          auto = function() {
            scope.rotate.y += 90;
            cleanup();
            return $timeout(auto, 20000);
          };
          randomVertical = function() {
            var h, v;
            v = Math.random();
            h = Math.random();
            scope.newV = (v - .5) * 1.5;
            scope.newH = (h - .5) * 2;
            return $timeout(randomVertical, 6000 * v);
          };
          scope.$watch('page', function() {
            if (scope.page === 'auto') {
              scope.rotate.y = -90;
              cleanup();
              randomVertical();
              auto();
              return scope.mode = 'auto';
            }
          });
          el.bind('pointerdown', function(e) {
            var startX, startY;
            startX = e.x;
            startY = e.y;
            return w.bind('pointermove', function(e) {
              return scope.dragX = ((e.x - startX) / scope.windowWidth) * scale;
            });
          });
          w.bind('pointerup', function(e) {
            return cleanup();
          });
          w.bind('resize', function() {
            return resize();
          });
          document.addEventListener('mouseout', function(e) {
            var from;
            e = (e ? e : window.event);
            from = e.relatedTarget || e.toElement;
            if (!from || from.nodeName === "HTML") {
              e.preventDefault();
              cleanup();
            }
          });
          return updateRotation();
        }
      };
    }
  ]);

  app.directive("graph", [
    '$window', '$filter', 'isMobile', function($window, $filter, isMobile) {
      return {
        link: function(scope, el, att) {
          var animate, area, data, gradient, gx, gy, height, line, margin, maximum, minimum, movingWindowAvg, parseDate, path, path2, resize, roll, svg, ticks, tooltip, updateChart, width, x, xAxis, y, yAxis;
          animate = true;
          if (isMobile()) {
            animate = false;
          }
          data = $filter('btcTrim')(scope.history, scope.trim);
          parseDate = d3.time.format("%b %Y").parse;
          margin = [30, 30, 50, 50];
          width = Math.max($window.innerWidth * .5, 300) - margin[1] - margin[3];
          height = Math.max($window.innerHeight * .5, 300) - margin[0] - margin[2];
          if (isMobile()) {
            height = width * 1.7 / 3;
          }
          svg = d3.select("#chart").append("svg").attr("viewBox", "0 0 width height").attr("preserveAspectRatio", "xMidYMid").attr("width", width + margin[3] + margin[1]).attr("height", height + margin[0] + margin[2]).append("svg:g").attr("transform", "translate(" + margin[3] + "," + margin[0] + ")");
          ticks = 5;
          if (isMobile()) {
            ticks = 3;
          }
          x = d3.time.scale().range([0, width]);
          y = d3.scale.linear().range([height, 0]);
          xAxis = d3.svg.axis().scale(x).orient("bottom").tickSize(3).tickPadding(3).ticks(ticks);
          yAxis = d3.svg.axis().scale(y).orient("left").tickSize(3).tickPadding(3).ticks(ticks).tickFormat(d3.format("$,f"));
          tooltip = d3.select('body').append('div').attr('class', 'tooltip').style('opacity', 0);
          movingWindowAvg = function(arr, step) {
            return arr.map(function(_, idx) {
              var result, wnd;
              wnd = arr.slice(idx - step, idx + step + 1);
              result = d3.sum(wnd) / wnd.length;
              if (isNaN(result)) {
                result = _;
              }
              return result;
            });
          };
          line = function(data, k) {
            data = data.map(function(d, i) {
              if (i > k) {
                return [k, data[k]];
              } else {
                return [i, d];
              }
            });
            return d3.svg.line().interpolate("monotone").x(function(d) {
              return x(d[1].date);
            }).y(function(d) {
              return y(d[1].price);
            })(data);
          };
          area = function(data, k) {
            data = data.map(function(d, i) {
              if (i > k) {
                return [k, data[k]];
              } else {
                return [i, d];
              }
            });
            return d3.svg.area().interpolate("monotone").x(function(d) {
              return x(d[1].date);
            }).y0(height).y1(function(d) {
              return y(d[1].price);
            })(data);
          };
          x.domain(d3.extent(data.map(function(d) {
            return d.date;
          })));
          maximum = d3.max(data.map(function(d) {
            return d.price;
          }));
          minimum = d3.min(data.map(function(d) {
            return d.price;
          }));
          y.domain([parseInt(minimum) - 5, parseInt(maximum) + 5]);
          gradient = svg.append("svg:defs").append("svg:linearGradient").attr("id", "gradient").attr("x2", "0%").attr("y2", "100%");
          gradient.append("svg:stop").attr("offset", "0%").attr("stop-color", "#fff").attr("stop-opacity", .2);
          gradient.append("svg:stop").attr("offset", "100%").attr("stop-color", "#fff").attr("stop-opacity", 0.0);
          roll = function(path, k, lineRoll) {
            if (lineRoll) {
              if (k < data.length) {
                return path.transition().duration(1).ease("linear").attr("d", line(data, k)).each("end", function() {
                  return roll(path, k + 1, true);
                });
              }
            } else {
              if (k < data.length) {
                return path.transition().duration(1).ease("linear").attr("d", area(data, k)).each("end", function() {
                  return roll(path, k + 1);
                });
              }
            }
          };
          path = svg.append("path").attr("d", area(data, 0)).attr("class", "area").attr("clip-path", "url(#clip)").style("fill", "url(#gradient)").style("stroke", 'none');
          roll(area, 0);
          path2 = svg.append("path").attr("d", line(data, 0)).style("fill", "none");
          roll(line, 0, true);
          gx = svg.append("svg:g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis);
          gy = svg.append("svg:g").attr("class", "y axis").attr("transform", "translate(0,0)").call(yAxis);
          resize = function() {
            width = Math.max($window.innerWidth * .5, 300) - margin[1] - margin[3];
            height = Math.max($window.innerHeight * .5, 300) - margin[0] - margin[2];
            return svg.attr("width", width + margin[3] + margin[1]).attr("height", height + margin[0] + margin[2]).attr("transform", "translate(" + margin[3] + "," + margin[0] + ")");
          };
          updateChart = function(redraw) {
            data = $filter('btcTrim')(scope.history, scope.trim);
            x.domain(d3.extent(data.map(function(d) {
              return d.date;
            })));
            maximum = d3.max(data.map(function(d) {
              return d.price;
            }));
            minimum = d3.min(data.map(function(d) {
              return d.price;
            }));
            y.domain([minimum - 4, maximum + 4]);
            gx.call(xAxis);
            gy.call(yAxis);
            if (animate) {
              if (redraw) {
                path.attr("d", area(data, 0)).transition().attr("clip-path", "url(#clip)");
                path2.attr("d", line(data, 0)).transition();
                roll(path2, 0, true);
                return roll(path, 0);
              } else {
                path.datum(data).transition().attr("clip-path", "url(#clip)").attr("d", area(data, data.lenght - 1));
                return path2.datum(data).transition().attr("d", line(data, data.lenght - 1));
              }
            } else {
              path.datum(data).attr("clip-path", "url(#clip)").attr("d", area(data, data.lenght - 1));
              return path2.datum(data).attr("d", line(data, data.lenght - 1));
            }
          };
          scope.$watch('history.length', function(newV, oldV) {
            var redraw;
            if (newV !== oldV) {
              redraw = false;
              if (Math.abs(newV - oldV) > 5) {
                redraw = true;
              }
              return updateChart(redraw);
            }
          });
          scope.$watch('trim', function(newV, oldV) {
            if (newV !== oldV) {
              return updateChart();
            }
          });
          return angular.element($window).bind('resize', resize);
        }
      };
    }
  ]);

  app.directive("water", [
    '$timeout', function($timeout) {
      return {
        link: function(scope, el, att) {}
      };
    }
  ]);

}).call(this);

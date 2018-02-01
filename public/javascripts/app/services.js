(function() {
  var app;

  app = angular.module("4real.services", []);

  app.factory('webGL', function($window) {
    return {
      initWater: function() {
        var error;
        try {
          if (!this.waterView) {
            this.waterView = new window.waterView();
          }
          return this.waterView;
        } catch (_error) {
          error = _error;
          return {
            error: error.message
          };
        }
      }
    };
  });

  app.factory('isMobile', function($window) {
    return function() {
      if ($window.innerWidth < 700) {
        return true;
      }
      return false;
    };
  });

  app.factory("socket", function($rootScope) {
    var socket;
    socket = io.connect('/');
    return {
      on: function(eventName, callback) {
        return socket.on(eventName, function() {
          var args;
          args = arguments;
          return $rootScope.$apply(function() {
            return callback.apply(socket, args);
          });
        });
      },
      emit: function(eventName, data, callback) {
        return socket.emit(eventName, data, function() {
          var args;
          args = arguments;
          return $rootScope.$apply(function() {
            if (callback) {
              return callback.apply(socket, args);
            }
          });
        });
      }
    };
  });

  app.factory("exchange", [
    '$rootScope', '$http', function($rootScope, $http) {
      return {
        getRates: function(callback) {
          return $http({
            method: "GET",
            url: "https://api.fixer.io/latest?base=USD&symbols=CEUR,CGBP,CRUB,CJPY,CCNY"
          }).success(function(data) {
            return callback(data.query);
          }).error(function() {
            return console.log("error getting exchange rates");
          });
        }
      };
    }
  ]);

  app.factory("btcHistory", [
    '$rootScope', '$http', function($rootScope, $http) {
      return {
        getHistory: function(callback) {
          return $http({
            method: 'GET',
            url: 'https://data.mtgox.com/api/2/BTCUSD/money/trades/fetch'
          }).success(function(data, status, headers, config) {
            return callback(data.data);
          }).error(function(data, status, headers, config) {
            return console.log('error geting historical data');
          });
        }
      };
    }
  ]);

  app.factory("siteMap", [
    function() {
      var data;
      return data = {
        main: {
          title: "4real Digital Agency",
          description: "4real is a digital agency specializing in designing and building scalable technology-driven websites & apps for the real world. It was started by Slava Balasanov and Analisa Teachworth in 2014. 4real aims to re-envision the web and reformulate communication-interaction channels. The fusion of technological and creative resources lends to the development of agile software and integrated design.",
          keywords: "4real, digital, agency, New York, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth",
          fbimg: 'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'
        },
        about: {
          title: "4real - About",
          description: "4real agency offers consultancy and expertise with a keen sense of global culture. 4REAL creates online experiences that span a variety of digital environments, including video, mobile, 3D, sound, and modular. The traditional gaps between user and brand, art and consumption, culture and commerce - these are spaces where technology can create wholly new cultural experiences for users. 4REAL creates integrated online systems, across an array of digital platforms, that facilitate a deeper two-way exchange between brands and consumers.",
          keywords: "4real, digital, agency, about, information, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth",
          fbimg: 'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'
        },
        charts: {
          title: "4real - Analytics",
          description: "At 4real studio we think realtime technology is becoming ever-more important.           The 'Analytics Section' illustrates a realtime bitcoin feed from the Bitstam exchange.           The chart is using Bitstamp API and D3",
          keywords: "4real, digital, agency, analytics, charts, bitcoin, bitstamp, realtime, prices, currency, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth",
          fbimg: 'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'
        },
        projects: {
          title: "4real - Projects",
          description: "These are some of the projects we have worked on. We like to fucus on projects that are culturally relevant and provide an opportunity to create a new and exciting interaction.",
          keywords: "4real, projects, digital, agency, projects, galleries, DISImages, Dismagazine, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth",
          fbimg: 'https://s3-us-west-2.amazonaws.com/4real/various/harddrive.jpg'
        },
        liquid: {
          title: "4real - Liquid Demo",
          description: "4real demo of liquid dynamics. This demo is done in WebGL using GLSL shader language to crete an interactive, realtime visualisation of liquid.",
          keywords: "4real, digital, agency, interactive, demo, water, Webgl, liquid, information, NYC, studio, web, interactive, realtime, website, Slava, Analisa Teachworth",
          fbimg: "https://s3-us-west-2.amazonaws.com/4real/various/liquid.png"
        }
      };
    }
  ]);

  app.factory('projectsService', [
    function() {
      var amazonUrl, data;
      amazonUrl = "https://s3-us-west-2.amazonaws.com/4real/projects/";
      data = [
        {
          title: 'Clinton Global Initiative',
          description: '',
          url: 'http://cgi-globe.herokuapp.com/',
          img: [
            {
              url: amazonUrl + 'cgi-web.jpg'
            }
          ],
          iphone: []
        }, {
          title: 'Clone Zone',
          description: '',
          url: 'http://clonezone.link',
          img: [
            {
              url: amazonUrl + 'clonezone.jpg'
            }
          ],
          iphone: [
            {
              url: amazonUrl + 'clonezone-phone.png'
            }
          ]
        }, {
          title: 'Thermal Online Experience',
          description: '',
          url: 'http://tgf-thermal.herokuapp.com',
          img: [
            {
              url: amazonUrl + 'thermal.jpg'
            }
          ],
          iphone: []
        }, {
          title: 'H0les',
          description: '',
          url: 'http://h0les.com',
          img: [
            {
              url: amazonUrl + 'holes-sm.jpg'
            }
          ],
          iphone: [
            {
              url: amazonUrl + 'holes-phone1.png'
            }
          ]
        }, {
          title: 'DIS Magazine Mobile',
          description: '',
          url: 'http://dismagazine.com',
          img: [
            {
              url: amazonUrl + 'dis-web.jpg'
            }
          ],
          iphone: [
            {
              url: amazonUrl + 'dis-phone.png'
            }
          ]
        }, {
          title: 'DIS Images',
          description: '',
          url: 'http://disimages.com',
          img: [
            {
              url: amazonUrl + 'disimages.jpg'
            }
          ],
          iphone: []
        }, {
          title: 'Gifpumper',
          description: 'realtime 3d collage platform',
          url: 'http://gifpumper.com',
          img: [
            {
              url: amazonUrl + 'gifpumper.jpg'
            }
          ],
          iphone: []
        }, {
          title: 'Kehinde Wiley Studio',
          description: 'website for artist Kehinde Wiley',
          url: 'http://kehindewiley.com',
          img: [
            {
              url: amazonUrl + 'kehindewiley.jpg'
            }
          ],
          iphone: [
            {
              url: amazonUrl + 'kwphone.png'
            }
          ]
        }, {
          title: 'The Digit',
          description: 'Augmented Reality App',
          url: 'http://balasan.net/thedigit/',
          img: [
            {
              url: amazonUrl + 'digit.jpg'
            }
          ],
          iphone: [
            {
              url: amazonUrl + "digitphone2.png"
            }
          ]
        }
      ];
      return {
        projects: data
      };
    }
  ]);

}).call(this);

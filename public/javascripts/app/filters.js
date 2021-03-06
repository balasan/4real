(function() {
  var app;

  app = angular.module("4real.filters", []);

  app.filter("ticker", [
    "$sce", function($sce) {
      return function(data, cur) {
        if (data) {
          return parseFloat(data).toFixed(2);
        }
      };
    }
  ]);

  app.filter("btcData", [
    function() {
      return function(data) {
        if (data[0]) {
          data.reverse();
          data.forEach(function(d) {
            d.price = parseFloat(d.last);
            return d.date = new Date(d.timestamp);
          });
        } else {
          data.price = parseFloat(data.last);
          data.date = new Date(parseInt(data.timestamp) * 1000);
        }
        return data;
      };
    }
  ]);

  app.filter("prefix", [
    function() {
      var dom, pre, styles;
      styles = window.getComputedStyle(document.documentElement, "");
      pre = (Array.prototype.slice.call(styles).join("").match(/-(moz|webkit|ms)-/) || (styles.OLink === "" && ["", "o"]))[1];
      dom = "WebKit|Moz|MS|O".match(new RegExp("(" + pre + ")", "i"))[1];
      return {
        dom: dom,
        lowercase: pre,
        css: "-" + pre + "-",
        js: pre[0].toUpperCase() + pre.substr(1)
      };
    }
  ]);

  app.filter("btcTrim", [
    function() {
      return function(data, trim) {
        var trimmed;
        trimmed = data.slice(Math.max(data.length - trim, 1));
        return trimmed;
      };
    }
  ]);

}).call(this);

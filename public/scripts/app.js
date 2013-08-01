(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name) {
    var path = expand(name, '.');

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  var list = function() {
    var result = [];
    for (var item in modules) {
      if (has(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.list = list;
  globals.require.brunch = true;
})();
require.register("collections/bearings", function(exports, require, module) {
var BearingsCollection, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BearingsCollection = (function(_super) {
  __extends(BearingsCollection, _super);

  function BearingsCollection() {
    _ref = BearingsCollection.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  BearingsCollection.prototype.model = require('models/bearing');

  BearingsCollection.prototype.url = 'http://local';

  return BearingsCollection;

})(Backbone.Collection);

});

require.register("initialize", function(exports, require, module) {
var AppView;

if (this.Hipster == null) {
  this.Hipster = {};
}

if (Hipster.Routers == null) {
  Hipster.Routers = {};
}

if (Hipster.Views == null) {
  Hipster.Views = {};
}

if (Hipster.Models == null) {
  Hipster.Models = {};
}

if (Hipster.Collections == null) {
  Hipster.Collections = {};
}

require('lib/helpers');

require('routers/main');

AppView = require('views/appView');

$(function() {
  Backbone.history.start({
    pushState: true
  });
  return Hipster.Views.AppView = new AppView;
});

});

require.register("lib/helpers", function(exports, require, module) {
Swag.Config.partialsPath = '../views/templates/';

});

require.register("models/bearing", function(exports, require, module) {
var BearingModel, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BearingModel = (function(_super) {
  __extends(BearingModel, _super);

  function BearingModel() {
    _ref = BearingModel.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  BearingModel.prototype.defaults = {
    directionX: 'east',
    directionY: 'north'
  };

  BearingModel.prototype.isValid = function() {
    return this.get('distance') > 0 && this.get('degrees') > 0;
  };

  return BearingModel;

})(Backbone.Model);

});

require.register("routers/main", function(exports, require, module) {
var MainRouter, main, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MainRouter = (function(_super) {
  __extends(MainRouter, _super);

  function MainRouter() {
    _ref = MainRouter.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  return MainRouter;

})(Backbone.Router);

main = new MainRouter();

module.exports = main;

});

require.register("views/appView", function(exports, require, module) {
var AppViewView, BearingsListView, MapView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BearingsListView = require('views/bearingsList');

MapView = require('views/map');

module.exports = AppViewView = (function(_super) {
  __extends(AppViewView, _super);

  function AppViewView() {
    _ref = AppViewView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  AppViewView.prototype.className = 'appView';

  AppViewView.prototype.el = '.app';

  AppViewView.prototype.initialize = function() {
    Hipster.Views.BearingsListView = new BearingsListView;
    Hipster.Views.MapView = new MapView;
    return this.render();
  };

  AppViewView.prototype.render = function() {};

  return AppViewView;

})(Backbone.View);

});

require.register("views/bearingsList", function(exports, require, module) {
var BearingModel, BearingsCollection, BearingsListItemView, BearingsListView, TimerView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BearingsListItemView = require('views/bearingsListItem');

BearingsCollection = require('collections/bearings');

BearingModel = require('models/bearing');

TimerView = require('views/timer');

module.exports = BearingsListView = (function(_super) {
  __extends(BearingsListView, _super);

  function BearingsListView() {
    _ref = BearingsListView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  BearingsListView.prototype.className = 'bearingsList';

  BearingsListView.prototype.template = require('views/templates/bearingsList');

  BearingsListView.prototype.el = '.bearingsList';

  BearingsListView.prototype.initialize = function() {
    Hipster.Collections.Bearings = new BearingsCollection;
    Hipster.Collections.Bearings.on('add', this.addNewItem);
    return this.render();
  };

  BearingsListView.prototype.render = function() {
    $(this.el).html(this.template);
    Hipster.Views.TimerView = new TimerView;
    return this.triggerAdd();
  };

  BearingsListView.prototype.addNewItem = function(bearing) {
    var view;
    view = new BearingsListItemView({
      model: bearing
    });
    return $('.bearingsList ul').append(view.render().el);
  };

  BearingsListView.prototype.triggerAdd = function() {
    return Hipster.Collections.Bearings.add(new BearingModel);
  };

  BearingsListView.prototype.triggerRace = function() {
    return Hipster.Views.MapView.trigger('race');
  };

  BearingsListView.prototype.events = function() {
    return {
      'click .action-add-item': 'triggerAdd',
      'click .action-race': 'triggerRace'
    };
  };

  return BearingsListView;

})(Backbone.View);

});

require.register("views/bearingsListItem", function(exports, require, module) {
var BearingsListItemView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BearingsListItemView = (function(_super) {
  __extends(BearingsListItemView, _super);

  function BearingsListItemView() {
    _ref = BearingsListItemView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  BearingsListItemView.prototype.className = 'bearingListItem';

  BearingsListItemView.prototype.tagName = 'li';

  BearingsListItemView.prototype.template = require('views/templates/bearingsListItem');

  BearingsListItemView.prototype.initialize = function() {
    return this.listenTo(this.model, 'destroy', this.remove);
  };

  BearingsListItemView.prototype.render = function() {
    $(this.el).html(this.template);
    return this;
  };

  BearingsListItemView.prototype.clear = function() {
    if (Hipster.Collections.Bearings.length > 1) {
      return this.model.destroy();
    }
  };

  BearingsListItemView.prototype.updateInput = function(evt) {
    return this.model.set(evt.currentTarget.name, evt.currentTarget.value);
  };

  BearingsListItemView.prototype.events = function() {
    return {
      'click .action-remove-item': "clear",
      'change input': 'updateInput',
      'keyup input': 'updateInput',
      'keyup select': 'updateInput',
      'keyup select': 'updateInput'
    };
  };

  return BearingsListItemView;

})(Backbone.View);

});

require.register("views/map", function(exports, require, module) {
var MapView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = MapView = (function(_super) {
  __extends(MapView, _super);

  function MapView() {
    _ref = MapView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  MapView.prototype.className = 'map';

  MapView.prototype.el = '.map';

  MapView.prototype.template = require('views/templates/map');

  MapView.prototype.initialize = function() {
    this.speed = 20;
    this.x = 100;
    this.y = 100;
    this.steps = [];
    this.step = 0;
    this.time = 0;
    this.elapsed = 0;
    this.render();
    this.timer = 0;
    this.playing = false;
    this.startTime = 0;
    this.on('race', this.race, this);
    this.on('step', this.drawStep, this);
    return this.on('tick', this.tick, this);
  };

  MapView.prototype.reset = function() {
    var buoys,
      _this = this;
    clearTimeout(this.timer);
    this.paper.clear();
    this.steps = [];
    this.x = 100;
    this.y = 100;
    this.time = 0;
    this.elapsed = 0;
    this.step = 0;
    this.boat = this.paper.image("images/dot.png", this.x - 11, this.y - 12, 22, 24);
    buoys = [
      {
        x: 140,
        y: 150
      }, {
        x: 260,
        y: 400
      }, {
        x: 350,
        y: 480
      }, {
        x: 460,
        y: 300
      }
    ];
    _.each(buoys, function(buoy) {
      return _this.paper.circle(buoy.x, buoy.y, 10);
    });
    return this.boundary = this.paper.path('M{0} {1} L{2} {3} {4} {5} {6} {7}z', buoys[0].x, buoys[0].y, buoys[1].x, buoys[1].y, buoys[2].x, buoys[2].y, buoys[3].x, buoys[3].y);
  };

  MapView.prototype.tick = function() {
    var diff,
      _this = this;
    if (this.playing) {
      this.time += 100;
      this.elapsed = Math.floor(this.time / 1000) / 10;
      if (Math.round(this.elapsed) === this.elapsed) {
        this.elapsed += ".0";
      }
      Hipster.Views.TimerView.trigger('update', this.elapsed);
      diff = (new Date().getTime() - this.startTime) - this.time;
      return this.timer = setTimeout(function() {
        return _this.trigger('tick', 100 - diff);
      });
    }
  };

  MapView.prototype.race = function() {
    var _this = this;
    this.reset();
    _.each(Hipster.Collections.Bearings.models, function(bearing) {
      if (bearing.isValid()) {
        return _this.steps.push(_this.makeMovement(bearing));
      } else {
        return bearing.destroy();
      }
    });
    if (this.steps.length > 0) {
      this.startTime = new Date().getTime();
      this.playing = true;
      this.timer = setTimeout(this.tick(), 100);
      return this.drawStep();
    }
  };

  MapView.prototype.drawStep = function() {
    var attrs, lastPath;
    attrs = {
      "stroke-dasharray": '.',
      'stroke-width': '3',
      'stroke': '#fff'
    };
    if (this.step < this.steps.length) {
      $("path").css('opacity', 0.4);
      this.paper.circle(this.boat.attr("x") + 11, this.boat.attr("y") + 12, 10).attr({
        fill: "#0289FD",
        stroke: "none",
        opacity: "0.2"
      });
      this.paper.path(this.steps[this.step].path).attr(attrs);
      lastPath = this.paper.path(this.steps[this.step].pathRadial).attr(attrs);
      this.boat.animate(this.steps[this.step].animation).toFront();
      return this.step++;
    } else {
      return this.playing = false;
    }
  };

  MapView.prototype.render = function() {
    this.paper = Raphael(this.el, '100%', '100%');
    return this.reset();
  };

  MapView.prototype.makeMovement = function(model) {
    var deg, dist, ew, newX, newY, ns, path, pathRadial,
      _this = this;
    dist = parseFloat(model.get('distance'));
    deg = parseFloat(model.get('degrees'));
    ew = model.get('directionX');
    ns = model.get('directionY');
    if (ew === "east") {
      path = Raphael.format("M{0} {1} L {2} {3}", this.x, this.y, this.x + dist, this.y);
      if (ns === "north") {
        newX = this.x + dist * Math.sin((deg + 90) * Math.PI / 180);
        newY = this.y + dist * Math.cos((deg + 90) * Math.PI / 180);
      } else {
        newX = this.x + dist * Math.sin((90 - deg) * Math.PI / 180);
        newY = this.y + dist * Math.cos((90 - deg) * Math.PI / 180);
      }
    } else {
      path = Raphael.format("M{0} {1} L {2} {3}", this.x, this.y, this.x - dist, this.y);
      if (ns === "north") {
        newX = this.x + dist * Math.sin((270 - deg) * Math.PI / 180);
        newY = this.y + dist * Math.cos((270 - deg) * Math.PI / 180);
      } else {
        newX = this.x + dist * Math.sin((deg + 270) * Math.PI / 180);
        newY = this.y + dist * Math.cos((deg + 270) * Math.PI / 180);
      }
    }
    pathRadial = Raphael.format("M{0} {1} L {2} {3}", this.x, this.y, newX, newY);
    this.x = newX;
    this.y = newY;
    return {
      path: path,
      pathRadial: pathRadial,
      animation: Raphael.animation({
        x: newX - 11,
        y: newY - 12
      }, (dist / this.speed) * 100, function() {
        return _this.trigger('step');
      })
    };
  };

  return MapView;

})(Backbone.View);

});

require.register("views/templates/bearingsList", function(exports, require, module) {
module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div id=\"timer\"></div>\n<ul>\n</ul>\n<h4><i class=\"icon-plus action-add-item\"> Add New</i></h4>\n<button class=\"btn btn-success action-race\">Race</button>";
  });
});

require.register("views/templates/bearingsListItem", function(exports, require, module) {
module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"row form-inline\">\n    Head\n    <input name=\"distance\" class=\"form-control input-small\" type=\"number\"> \n    miles at \n    <input name=\"degrees\" class=\"form-control input-small\" type=\"number\" min=\"0\" max=\"360\" step=\"1\"> degrees\n    \n    <select class=\"form-control input-small\" name=\"directionY\">\n      <option value=\"north\">north</option>\n      <option value=\"south\">south</option>\n    </select>\n   of\n    <select class=\"form-control input-small\" name=\"directionX\">\n      <option value=\"east\">east</option>\n      <option value=\"west\">west</option>\n    </select>\n\n<i class=\"icon-remove action-remove-item\"></i>\n</div>";
  });
});

require.register("views/templates/map", function(exports, require, module) {
module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div id=\"map\"></div>";
  });
});

require.register("views/templates/timer", function(exports, require, module) {
module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<i class=\"icon-time\"></i>&nbsp;";
  if (stack1 = helpers.time) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.time; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + " seconds";
  return buffer;
  }

  buffer += "<h3>";
  stack1 = helpers['if'].call(depth0, depth0.time, {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "&nbsp;</h3>";
  return buffer;
  });
});

require.register("views/timer", function(exports, require, module) {
var TimerView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = TimerView = (function(_super) {
  __extends(TimerView, _super);

  function TimerView() {
    _ref = TimerView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  TimerView.prototype.el = '#timer';

  TimerView.prototype.template = require('views/templates/timer');

  TimerView.prototype.initialize = function() {
    this.on('update', this.render);
    return this.render(null);
  };

  TimerView.prototype.render = function(time) {
    return $('#timer').html(this.template({
      time: time
    }));
  };

  return TimerView;

})(Backbone.View);

});


//@ sourceMappingURL=app.js.map
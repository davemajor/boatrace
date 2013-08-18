var express = require('express')
  , mongoose = require('mongoose');
var app = express();
var opts = { server: { auto_reconnect: true, socketOptions: { keepAlive: 1 }}};

app.configure('development', function(){
  url = 'mongodb://localhost/boatrace';
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  console.log("DEVELOPMENT")
});

app.configure('production', function(){
  app.use(express.errorHandler());
  console.log("production")
});

//mongoose.set('debug', true);
mongoose.connect(url, opts);

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function callback() {
  console.log('Connected to DB');
});

// User Schema
var routeSchema = mongoose.Schema({
  time: { type: Number},
  bearings: {type: Array}
});

var ObjectId = require('mongoose').Types.ObjectId;

var Route = mongoose.model('Route', routeSchema);

// configure Express
app.configure(function() {
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use('/', express.static(__dirname + '/public'));
  app.use('/bretvictor', express.static(__dirname + '/public'));
  app.use('/', app.router);
});

app.get('/api/routes', function (req, res){
  var query = Route.find({},{time: 1, bearings: 0}).lean()
  return query.exec(function (err, routes) {
    if (!err) {
      return res.json(routes);
    } else {
     return res.status(200);
    }
  });
})

app.post('/api/routes', function(req, res, next){
  var route = new Route(req.body);
  route.save(function(err) {
    if(err) {
      console.log(err);
    } else {
      return res.send(route);
    }
  })
});

app.use(app.router);

app.listen(3336, function() {
  console.log('Express server listening on port 3336');
});

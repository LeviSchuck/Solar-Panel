var express = require('express');
var app = express();
var server = require('http').createServer(app)
  , io = require('socket.io').listen(server);
var spawn = require('child_process').spawn;
var tailed = [];
var counter = 0;

var addTailFunc = function(filename,name){
	var tail = {};
	tail.proc = spawn("tail", ["-f", filename]);
	tail.sockets = [];
	tail.name = name;
	tail.proc.stdout.on("data", function (data) {
		console.log("Got data "+data);
	    tail.sockets.forEach(function(socket){
	    	socket.emit('tail', { text: data.toString('utf8'), name:name });
	    });
	});
	console.log("Listening to "+filename);
	tailed.push(tail);
}


app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.static(__dirname + '/public'));
app.get('/', function(req, res){
  res.render('index',
  {
  	tailed: tailed
  });
});

io.sockets.on('connection', function (socket) {
	var names = ""
	tailed.forEach(function(tail){
		names += tail.name + ",";
		tail.sockets.push(socket);
	});
	if(names == "") names = "Nothing.";
	socket.emit('tail', { text: "Listening to "+names +"\n"});
});

server.listen(1997);
console.log('Listening on port 1997');
addTailFunc("/home/vagrant/date.txt","Date text");
addTailFunc("/home/vagrant/test.txt","Test text");
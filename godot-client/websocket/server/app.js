var http = require('http'),
	WS = require('ws').Server;


// Send non-compliant requests to /public/index.html
var server = http.createServer(function(req, res) {
	res.writeHead(200, { 'Content-type': 'text/html'});
	res.end(fs.readFileSync(__dirname + '/public/index.html'));
}).listen(3000, function() {
	console.log('Listening at: http://localhost:3000');
});

var wss = new WS({server: server, perMessageDeflate: false})


wss.on('connection', function(socket) {
	console.log('User Connected: ' + socket._socket.remoteAddress.replace("::ffff:","") + " - " + new Date())
	
	socket.on('message', function(msg) {
		console.log(msg)
    wss.clients.forEach(function(client) {
			try {
				client.send(msg)
			} catch (err) {
				err
			}
    });
	});
	
	socket.on('error', function(er) {
		console.log(er)
	});
	
	// user disconnected
	socket.on('close', function(connection) {
		console.log("User Disconnected: " + socket._socket.remoteAddress.replace("::ffff:","") + " - " + new Date())
	});
});
    

function _on_time() {
	var msg = new Date().toString()
	wss.clients.forEach(function(client) {
		try {
			client.send(msg)
		} catch (err) {
			err
		}
	});
};

setInterval(_on_time, 3000)

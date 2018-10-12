var http = require('http'),
	ws = require('websocket').server;

// Send bad requests to ./public/index.html
var server = http.createServer(function(req, res) {
	res.writeHead(200, { 'Content-type': 'text/html'});
	res.end(fs.readFileSync(__dirname + '/public/index.html'));
}).listen(3000, function() {
	console.log('Listening at: http://localhost:3000');
});

// Start server
var wsServer = new ws({
	httpServer: server,
	autoAcceptConnections: false,
	maxReceivedFrameSize: 125,    // Max of 125 bytes per frame
	maxReceivedMessageSize: 8192}); // Max of 8192 bytes per message

wsServer.on('request', function(request) {
	try {
		var connection = request.accept('namethiswhatever', request.origin);
	} catch(err) {
		console.log(err);
		return;
	}
	console.log("User Connected: " + connection.remoteAddress.replace("::ffff:","") + " - " + new Date());
	
	connection.on('message', function(msg) {
		if (msg.type === 'utf8') {
			console.log('Received Message: ' + msg.utf8Data);
			connection.sendUTF(msg.utf8Data);
		} else if (msg.type === 'binary') {
			console.log('Received Binary Message of ' + msg.binaryData.length + ' bytes');
			connection.sendBytes(msg.binaryData);
		}
	});
	
	connection.on('error', function(err) {
		console.log(err);
	});
	
	connection.on('close', function(reasonCode, description) {
		console.log("User Disconnected: " + connection.remoteAddress.replace("::ffff:","") + " - " + new Date());
	});
});

function _on_time() {
	var msg = new Date().toString();
	wsServer.connections.forEach(function(client) {
		try {
			client.sendUTF(msg);
		} catch (err) {
			console.log(err);
		}
	});
};

setInterval(_on_time, 3000)

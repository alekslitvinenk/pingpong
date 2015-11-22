// Load the TCP Library
net = require('net');

// Keep track of the chat clients
var clients = [];
var games = [];
var awaitingClients = [];

// Start a TCP Server
net.createServer(function (socket) {
	socket.setNoDelay(true);

	// Identify this client
	socket.name = socket.remoteAddress + ":" + socket.remotePort;

	// Put this new client in the list
	clients.push(socket);

	// Send a nice welcome message and announce
	process.stdout.write(socket.name + " joined the server\n");

	if(awaitingClients.length){
		var gameID = Math.random();

		var enemy = awaitingClients.shift();

		socket.gameID = gameID;
		enemy.gameID = gameID;

		games[gameID] = {peer1: socket, peer2: enemy};

		process.stdout.write("game created for " + socket.name + " and " + enemy.name + "\n");
	}else{
		awaitingClients.push(socket);
	}

	// Handle incoming messages from clients.
	socket.on('data', function (data) {
		//process.stdout.write(data.readDoubleLE(0) + "\n");

		if(socket.gameID){
			var gameObj = games[socket.gameID];

			for (var peer in gameObj){
				if(gameObj[peer] === socket){
					continue;
				}

				var posBuf = new Buffer(8);
				data.copy(posBuf);

				gameObj[peer].write(posBuf);
			}
		}
	});

	// Remove the client from the list when it leaves
	socket.on('end', function () {
		if(socket.gameID){
			delete games[socket.gameID];
		}

		var awaitingID = awaitingClients.indexOf(socket);

		if(awaitingID != -1){
			delete awaitingClients[awaitingID];
		}

		clients.splice(clients.indexOf(socket), 1);
		process.stdout.write(socket.name + " left the server.\n");
	});

}).listen(5000);

// Put a friendly message on the terminal of the server.
console.log("Game server running at port 5000\n");
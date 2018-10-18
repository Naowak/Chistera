import signal
import sys
import ssl
from SimpleWebSocketServer import WebSocket, SimpleWebSocketServer, SimpleSSLWebSocketServer
from optparse import OptionParser
import json
import GameManager

free_ids = list(range(1, 100))
clients = []
gm = GameManager.GameManager()

def encode(data) :
	return json.dumps(data)

def decode(mess) :
	return json.loads(mess)

class MyClient(WebSocket) :

	def handleMessage(self) :
		print("Message reçu : ", self.data)
		dico = decode(self.data)
		gm.treat_request(self, dico)
		# if dico["action"] == "new_game" :
		# 	pos_center = [550, 300]
		# 	ray = 5
		# 	theMap = Grid.Grid(ray)
		# 	coord_ninja = [0, 0]
		# 	msg = {"action" : "new_game", 
		# 		"pos_center" : pos_center, 
		# 		"grid" : theMap.get_serializable_grid(), 
		# 		"coord_ninja" : coord_ninja}
		# 	mess = encode(msg)
		# 	self.sendMessage(mess)
		# 	print("Message envoye : "  + mess)

	# def handleMessage(self) :


	def handleConnected(self) :
		print(self.address, 'connected')
		self.id = free_ids.pop()
		# for client in clients:
		# 	client.sendMessage(self.address[0] + u' - connected')
		clients.append(self)

	def handleClose(self) :
		clients.remove(self)
		free_ids.append(self.id)
		print(self.address, 'closed')

	




if __name__ == "__main__" :

	parser = OptionParser(usage="usage: %prog [options]", version="%prog 1.0")
	parser.add_option("--host", default='', type='string', action="store", dest="host", help="hostname (localhost)")
	parser.add_option("--port", default=8000, type='int', action="store", dest="port", help="port (8000)")
	parser.add_option("--example", default='echo', type='string', action="store", dest="example", help="echo, chat")
	parser.add_option("--ssl", default=0, type='int', action="store", dest="ssl", help="ssl (1: on, 0: off (default))")
	parser.add_option("--cert", default='./cert.pem', type='string', action="store", dest="cert", help="cert (./cert.pem)")
	parser.add_option("--key", default='./key.pem', type='string', action="store", dest="key", help="key (./key.pem)")
	parser.add_option("--ver", default=ssl.PROTOCOL_TLSv1, type=int, action="store", dest="ver", help="ssl version")

	(options, args) = parser.parse_args()

	cls = MyClient

	if options.ssl == 1:
		server = SimpleSSLWebSocketServer(options.host, options.port, cls, options.cert, options.key, version=options.ver)
	else:
		server = SimpleWebSocketServer(options.host, options.port, cls)
	print("serveur créer")

	def close_sig_handler(signal, frame):
		server.close()
		sys.exit()

	signal.signal(signal.SIGINT, close_sig_handler)
	server.serveforever()
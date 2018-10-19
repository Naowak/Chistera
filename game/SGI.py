#coding : utf-8

import asyncio

class SGI():

	def __init__(self, ID) :
		self.game_id = ID
		self.is_finished = False
		self.clients = {"players": {}, "viewers": {}}

	def get_state(self) :
		pass

	def bind_player(self, client) :
		self.clients["players"][client.id] = client
		print(str(client.id) + " " + client.name + "connected to the game as Player.")

	def bind_viewer(self, viewer) :
		self.clients["viewers"][client.id] = client
		print(str(client.id) + " " + client.name + "connected to the game as Viewer.")

	def unbind_client(self, client)	:
		if client.id in self.clients["players"] :
			print(client.name + "quit the game.")
			self.is_finished = True
		elif client.id in self.clients["viewers"] :
			print(client.name + "stop viewing the game.")
			del self.clients["viewers"][client.id]
		else :
			print("Error : client key not found, key=", client.id)

	def notify_all_clients(self) : 
		msg = self.get_state()
		for player in self.clients["players"].values() :
			player.send(msg)
		for viewer in self.clients["viewers"].values() :
			viewer.send(msg)

	def notify_all_players(self) :
		msg = self.get_state()
		for player in self.clients["players"].values() :
			player.send(msg)

	def notify_all_viewers(self) :
		msg = self.get_state()
		for viewer in self.clients["viewers"].values() :
			viewer.send(msg)

	def quit(self) :
		"""End the game"""
		clients = list(self.clients["viewers"].values())+list(self.clients["players"].values())
		for client in clients:
			client.on_quit_game(self)
		print("Game ", self.game_id, "close")
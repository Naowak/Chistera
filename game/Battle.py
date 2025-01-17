#coding: utf-8

import random
import time
import Grid
import Character
import SGI 
import threading

HEROES = ["Ninja"]

class Player :

	def __init__(self, sock) :
		self.sock = sock
		self.team = None
		self.ready = False

	def create_team(self, team, grid) :
		#dois changer avec la création de character
		#et pour deux équipes
		myteam = []
		for name in team :
			lp = 100
			mana = 100
			mp = 6
			available_coords = [grid.coords_begin[i] for i in range(len(grid.coords_begin)) if grid.get_cell(grid.coords_begin[i]).is_empty]
			coord = random.choice(available_coords)
			char = Character.Character(name, lp, mana, mp, coord, self)
			myteam += [char]
			grid.get_cell(coord).append_character(char)
		self.team = myteam
		return myteam

	def get_id(self) :
		return self.sock.id 

	def get_name(self) :
		return self.sock.name


class Battle(SGI.SGI) :

	TIME_ONE_TURN = 10
	RAY_MAP = 10

	def __init__(self, game_id, client, team) :
		super().__init__(game_id)
		self.player_one = Player(client)
		self.bind_player(self.player_one.sock)

		self.grid = Grid.Grid(self.RAY_MAP)
		self.team = self.player_one.create_team(team, self.grid)
		self.turn = 0
		self.timeline = self.get_timeline()

		self.step = "not_begin"
		self.action = "none"
		self.on_player = self.player_one #To MODIFY
		self.on_character = None
		self.iterator_timeline = 0
		self.error = ""
		self.pass_turn = False

		self.time_begin_turn = None

		self.my_thread = None
	# ------------------------- Access Information ----------------------



	def get_coords_begin(self) :
		# Il faudra ajouter des coorddonnées spécifiques aux deux joueurs !!!!
		return self.grid.coords_begin

	def get_timeline(self) :
		timeline = []
		for elem in self.team :
			timeline += [elem]
		return timeline

	def is_game_finished(self) :
		for char in self.team :
			if not char.is_dead() :
				return False
		return True


	#----------------------- Manager's Information ----------------------

	def get_state(self) :
		#on a besoin d'envoye seulement les characters
		data = {}
		data_team = [char.get_state() for char in self.team]
		data["step"] = self.step
		data["action"] = self.action
		data["team"] = data_team
		data["on_player"] = self.on_player.get_name() if self.on_player else "Unknown"
		data["on_character"] = self.on_character.name if self.on_character else "None"
		data["turn"] = self.turn
		data["error"] = self.error
		self.error = ""
		self.action = {}
		return data

	def get_character(self, client, name) :
		#to change when 2 players
		p = self.player_one if client.id == self.player_one.get_id() else None
		if p :
			for c in self.player_one.team :
				if c.name == name :
					return c
			self.error += "Error : No character with name " + name + " in " + self.player_one.get_name() + " team."
		else :
			self.error += "Error : No player " + client.id + " in game " + str(self.game_id)

	# ----------------------- Actions ----------------------


	def move_character_while_coords_begin(self, player, data) :
		self.step = "coords_begin"
		self.action = {"name" : "move_character"}
		inc_cell = self.grid.get_cell(data["action"]["coord"])
		character = self.get_character(player.sock, data["action"]["character"])
		out_cell = self.grid.get_cell(character.coord)
		if inc_cell.is_empty :
			if inc_cell.coord in self.get_coords_begin() :
				out_cell.remove_character()
				inc_cell.append_character(character)
				character.coord = inc_cell.coord
				self.action["character"] = character.name
				self.action["coord"] = inc_cell.coord
			else :
				self.error += "Error : Cell not in coords_bin"
		else :
			self.error += "Error : Cell not empty."

	def player_ready(self, player) :
		player.ready = True
		if self.player_one.ready : # TO MODIFY
			self.step = "coords_begin"
			self.on_player = self.player_one
			self.give_coords_begin()
			self.my_thread = threading.Thread(target=self.play_game, args=())
			self.my_thread.start()

	def give_coords_begin(self) :
		## USE NOTIFY ALL CLIENTS
		gid = self.game_id
		msg = {"step" : "coords_begin",
			"action" : { "name" : "give_coords_begin",
				"coords" : self.get_coords_begin(), #TO MODIFY
				"time_one_turn" : self.TIME_ONE_TURN,
				"on_player" : self.player_one.sock.name}
			}
		self.on_player.sock.send(msg)

	# -------------------------- Manager --------------------------

	def verify_client(self, client) :
		p = self.player_one if client.id == self.player_one.get_id() else None
		if not p :
			self.error += "Error : no player " + client.name + " in game " + str(self.game_id)
			return False
		elif p != self.on_player :
			self.error += "Error : not " + client.name + " turn to play."
			return False
		return p


	def treat_request(self, client, data) :
		player = self.verify_client(client)
		if not player :
			self.notify_all_clients()
			return

		if data["step"] == "new_game" and self.step == "new_game":
			if data["action"]["name"] == "ready" :
				self.player_ready(player)
		else :
			if data["step"] == "coords_begin" and self.step == "coords_begin" :
				if data["action"]["name"] == "move_character" :
					self.move_character_while_coords_begin(player, data)
					self.notify_all_clients()

				elif data["action"]["name"] == "pass_turn" :
					self.pass_turn = True

			if data["step"] == "on_turn" :
				self.pass_turn = True



	# ------------------------- Turn Wait --------------------------

	def play_game(self) :
		self.wait_coords_begin()
		self.iterator_timeline = -1
		self.turn = 0
		self.prepare_turn()
		while not self.is_finished and not self.is_game_finished() :
			# POUR LINSTANT ON LAISSE DEUX MESSAGES SI UN CLIENT SE DECO
			self.prepare_turn()
			self.notify_all_clients()
			self.wait_one_turn()
		self.is_finished = True
		self.step = "finished"
		self.action = ""
		self.notify_all_clients()

	def catch_client_out(self) :
		if not self.player_one.sock.is_connected :
			self.error += "Error : Player " + self.player_one.sock.name + " has deconnected."
			self.is_finished = True
			print(self.error)

	def wait_coords_begin(self) :
		self.time_begin_turn = time.time()
		while not self.pass_turn and self.time_begin_turn + self.TIME_ONE_TURN > time.time() and not self.is_finished :
			self.catch_client_out()
			time.sleep(1)
		self.pass_turn = False

	def wait_one_turn(self) :
		self.time_begin_turn = time.time()
		while not self.pass_turn and self.time_begin_turn + self.TIME_ONE_TURN > time.time() and not self.is_finished :
			self.catch_client_out()
			time.sleep(1)		

	def prepare_turn(self) :
		self.step = "on_turn"
		self.action = {"name" : "new_turn", "time_one_turn" : self.TIME_ONE_TURN}
		self.pass_turn = False
		self.iterator_timeline = (self.iterator_timeline + 1) % len(self.timeline)
		if self.iterator_timeline == 0 :
			self.turn += 1
		self.on_character = self.timeline[self.iterator_timeline]
		self.on_player = self.on_character.player



#coding: utf-8

import json
import sys
import asyncio
sys.path.append('../game/')
import Battle

NUMBER_PLAYER_GAME = 1
free_game_ids = list(range(1, 100))

class GameManager() :

	def __init__(self) :
		self.games = {}
		self.ask_to_play = []

	# ---------------------- Access Information -------------

	def get_game_from_id(self, gid) :
		return self.games[gid]

	# ---------------------- Actions -------------------------

	def treat_request(self, client, data) :
		if not "step" in data :
			print("Step pas défini !")
		elif data["step"] == "ask_to_play" :
			self.action_ask_to_play(client, data)
		else :
			gid = data["gid"]
			self.games[gid].treat_request(client, data)

	def action_ask_to_play(self, client, data) :
		self.ask_to_play += [[client, data["team"]]]
		msg = {"step" : "ask_to_play", "action" : {"name" : "wait"}}
		client.send(msg)
		if len(self.ask_to_play) >= NUMBER_PLAYER_GAME :
			self.create_game()

	def create_game(self) :
		client, team = self.ask_to_play.pop(0)
		game_id = free_game_ids.pop(0)
		new_battle = Battle.Battle(game_id, client, team) # To MODIFY
		self.games[game_id] = new_battle

		msg = {"gid" : game_id,
			"step" : "new_game",
			"grid" : new_battle.grid.get_serializable_grid(),
			"state" : new_battle.get_state()}
		client.send(msg)

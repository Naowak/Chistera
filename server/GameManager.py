#coding: utf-8

import json
import sys
import asyncio
sys.path.append('../game/')
import Battle

NUMBER_PLAYER_GAME = 1
free_game_ids = list(range(1, 100))
loop = asyncio.get_event_loop()

class GameManager() :

	def __init__(self) :
		self.games = {}
		self.ask_to_play = []

	def treat_request(self, client, data) :
		if not "step" in data :
			print("Step pas défini !")
		if data["step"] == "ask_to_play" :
			self.ask_to_play += [[client, data["team"]]]
			if len(self.ask_to_play) >= NUMBER_PLAYER_GAME :
				self.create_game()


	def create_game(self) :
		player, team = self.ask_to_play.pop()
		game_id = free_game_ids.pop()
		new_battle = Battle.Battle(game_id, player, team)
		self.games[game_id] = new_battle

		msg = {"step" : "new_game",
			"grid" : new_battle.grid.get_serializable_grid(),
			"state" : new_battle.get_state()}
		player.send(msg)

	def play_the_game(self, gid) :
		game = self.get_game_from_id(gid)
		loop.run_until_complete(game.run())

	def get_game_from_id(self, gid) :
		return self.games[gid]



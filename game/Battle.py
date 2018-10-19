#coding: utf-8

import random
import asyncio
import time
import Grid
import Character
import SGI 

TIME_TURN = 30
RAY_MAP = 10
HEROES = ["Ninja"]

class Battle(SGI.SGI) :

	def __init__(self, game_id, player, team) :
		super().__init__(game_id)
		self.bind_player(player)

		self.grid = Grid.Grid(RAY_MAP)
		self.team = self.create_team(team)
		self.on_character = None
		self.turn = -1
		self.timeline = self.get_timeline()

	def create_team(self, team) :
		#dois changer avec la création de character
		#et pour deux équipes
		myteam = []
		for name in team :
			lp = 100
			mana = 100
			mp = 6
			coord = random.choice(self.grid.available_coords)
			myteam += [Character.Character(name, lp, mana, mp, coord)]
		return myteam

	def get_cells_start(self) :
		return self.grid.cells_start

	def get_state(self) :
		#on a besoin d'envoye seulement les characters
		data = {}
		data_team = [char.get_state() for char in self.team]
		data["team"] = data_team
		return data

	def get_timeline(self) :
		timeline = []
		for elem in self.team :
			timeline += [elem]
		return timeline

	def is_finished(self) :
		for char in self.team :
			if not char.is_dead() :
				return False
		return True

	async def run(self) :
		while not self.is_finished : 
			self.turn += 1
			for i, whos_turn in enumerate(self.timeline) :
				if self.is_finished :
					break
				self.on_character = whos_turn
				time_begin_turn = time.time()
				while time.time() < time_begin_turn + TIME_TURN :
					asyncio.sleep(0)





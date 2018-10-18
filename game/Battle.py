import random

import Grid
import Character

RAY_MAP = 10
HEROES = ["Ninja"]

# class Team() :

# 	def __init__(self) :
# 		self.frist_hero = None
# 		self.second_hero = None
# 		self.third_hero = None

# 	def 

class Battle() :

	def __init__(self, game_id, player_id, team) :
		self.game_id = game_id
		self.player_id = player_id
		self.grid = Grid.Grid(RAY_MAP)
		self.team = self.create_team(team)
		self.on_character = None

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

	def get_state(self) :
		print(self.team)
		data = {}
		data_team = [char.get_state() for char in self.team]
		data["team"] = data_team
		return data


	# def run(self) :

	# 	def is_game_finished(self) :
	# 		#dois changer pour 2 équipe
	# 		for character in self.team :
	# 			if character.lp > 0 :
	# 				return False
	# 		return True

	# 	while not is_game_finished(self) :




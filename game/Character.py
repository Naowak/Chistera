#coding: utf-8

class Character() :

	def __init__(self, name, lp, mana, mp, coord, player) :
		self.name = name
		self.lp = lp
		self.mana = mana
		self.mp = mp
		self.coord = coord
		self.player = player

	def get_state(self) :
		return {"name" : self.name,
			"lp" : self.lp,
			"mana" : self.mana,
			"mp" : self.mp,
			"coord" : self.coord}

	def is_dead(self) :
		return self.lp == 0 



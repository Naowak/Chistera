class Character() :

	def __init__(self, name, lp, mana, mp, coord) :
		self.name = name
		self.lp = lp
		self.mana = mana
		self.mp = mp
		self.coord = coord

	def move(self, coord) :
		self.coord = coord

	def get_state(self) :
		return {"name" : self.name,
			"lp" : self.lp,
			"mana" : self.mana,
			"mp" : self.mp,
			"coord" : self.coord}


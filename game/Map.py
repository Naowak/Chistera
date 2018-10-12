
class Cell() :

	kinds = ["hole", "flor", "full"]

	def __init__(self, kind, coord) :
		self.kind = kind
		self.coord = coord
		self.is_empty = True

	def __str__(self) :
		return '[' + str(self.coord) + " : "  + str(self.kind) + ']'


class Map() :

	q = 0
	r = 0

	def __init__(self, ray) :
		self.grid = []
		self.create_map(ray)

	def create_map(self, ray) :
		"""Create the map"""

		def create_one_line(self, nb_cell, q, r, ray) :
			for i in range(nb_cell) :
				c = Cell("flor", [q, r])
				self.grid[r + ray] += [c]
				q += 1
			return q, r

		nb_cell = ray + 1
		q = 0
		r = -ray
		for i in range(ray) :
			self.grid += [list()]
			q, r = create_one_line(self, nb_cell, q, r, ray)
			nb_cell += 1
			r += 1
			q = -ray -r
		for i in range(ray + 1) :
			self.grid += [list()]
			q, r = create_one_line(self, nb_cell, q, r, ray)
			r += 1
			q = -ray
			nb_cell -= 1

	def get_serializable_grid(self) :
		serializable_grid = []
		for i, line in enumerate(self.grid) :
			serializable_grid += [list()]
			for c in line :
				serializable_grid[i] += [(c.coord, c.kind)]
		return serializable_grid

	def __str__(self) :
		return str(self.get_serializable_grid())


if __name__ == '__main__': 
	m = Map(5)
	print(m)



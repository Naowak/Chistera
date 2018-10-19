#coding: utf-8

import random

class Cell() :

	kinds = ["hole", "flor", "full"]

	def __init__(self, kind, coord) :
		self.kind = kind
		self.coord = coord
		self.is_empty = True

	def __str__(self) :
		return '[' + str(self.coord) + " : "  + str(self.kind) + ']'


class Grid() :

	q = 0
	r = 0

	def __init__(self, ray) :
		self.grid = []
		self.create_map(ray)
		self.available_coords = self.get_available_coords()

	def create_map(self, ray) :
		"""Create the map"""

		def random_kind() :
			a = random.random()
			if a < 0.1 :
				return "full"
			if a < 0.15 :
				return "empty"
			return "flor"

		def create_one_line(self, nb_cell, q, r, ray) :
			for i in range(nb_cell) :
				kind = random_kind()
				c = Cell(kind, [q, r])
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

	def get_available_coords(self) :
		available_coords = []
		for line in self.grid :
			for cell in line :
				if cell.kind == "flor" :
					available_coords += [cell.coord]
		return available_coords


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



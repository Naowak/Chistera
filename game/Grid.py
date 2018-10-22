#coding: utf-8

import random

NB_CELLS_START = 5

class Cell() :

	kinds = ["hole", "flor", "full"]

	def __init__(self, kind, coord) :
		self.kind = kind
		self.coord = coord
		self.is_empty = True
		self.character = None

	def append_character(self, character) :
		if self.is_empty :
			self.is_empty = False
			self.character = character

	def remove_character(self) :
		self.is_empty = True
		self.character = None

	def __str__(self) :
		return '[' + str(self.coord) + " : "  + str(self.kind) + ']'


class Grid() :

	q = 0
	r = 0

	def __init__(self, ray) :
		self.ray = ray
		self.grid = []
		self.create_map()
		self.available_coords = self.get_available_coords()
		self.coords_begin = [random.choice(self.available_coords) for _ in range(5)]

	def create_map(self) :
		"""Create the map"""

		def random_kind() :
			a = random.random()
			if a < 0.1 :
				return "full"
			if a < 0.15 :
				return "empty"
			return "flor"

		def create_one_line(self, nb_cell, q, r) :
			for i in range(nb_cell) :
				kind = random_kind()
				c = Cell(kind, [q, r])
				self.grid[r + self.ray] += [c]
				q += 1
			return q, r

		nb_cell = self.ray + 1
		q = 0
		r = -self.ray
		for i in range(self.ray) :
			self.grid += [list()]
			q, r = create_one_line(self, nb_cell, q, r)
			nb_cell += 1
			r += 1
			q = -self.ray -r
		for i in range(self.ray + 1) :
			self.grid += [list()]
			q, r = create_one_line(self, nb_cell, q, r)
			r += 1
			q = -self.ray
			nb_cell -= 1

	def get_cell(self, coord) :
		q = coord[0]
		r = coord[1]
		j = coord[1] + self.ray
		i = None
		if coord[1] <= 0 :
			i = coord[0] + self.ray + coord[1]
		else :
			i = coord[0] + self.ray
		return self.grid[j][i]

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



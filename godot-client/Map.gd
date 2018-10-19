extends Node2D

var Cell = preload("res://Cell.tscn")
var Cell_full = preload("res://Cell_full.tscn")

var mv_r = [47, 0]
var mv_dr = [24, 31]
var diff_y = -6 #between flor and full
var pos_center = [500, 380]

var grid = null
var ray = 0
var nb_cells_flor = 0
var last_cell_selected_coord = [null, null]

func create_map_from_grid(_grid) :
	grid = _grid
	for line in _grid :
		for elem in line :
			var coord = elem[0]
			if coord[0] > ray : #on trouve le rayon 
				ray = coord[0]
			var kind = elem[1]
			var cell = null
			if kind  == "empty" :
				pass
			elif kind == "flor" :
				cell = Cell.instance()
				nb_cells_flor += 1
			elif kind == "full" :
				cell = Cell_full.instance()
				cell.position.y = -6
			if cell != null :
				cell.q = coord[0]
				cell.r = coord[1]
				cell.position.x += pos_center[0] + mv_r[0] * coord[0] + mv_dr[0] * coord[1]
				cell.position.y += pos_center[1] + mv_dr[1] * coord[1]
				var name = 'Cell_' + str(coord[0]) + '_' + str(coord[1])
				cell.set_name(name)
				add_child(cell)
				cell.get_node("Label").text = str(coord[0]) + ' / ' + str(coord[1])

func get_coord_ul(q, r) :
		return [q, r-1]
func get_coord_ur(q, r) :
	return [q+1, r-1]
func get_coord_l(q, r) :
	return [q-1, r]
func get_coord_r(q, r) :
	return [q+1, r]
func get_coord_dl(q, r) :
	return [q-1, r+1]
func get_coord_dr(q, r) :
	return [q, r+1]
func verify_coords_in_map(coord) :
	var q = coord[0]
	var r = coord[1]
	var s = - q - r
	if abs(s) + abs(q) + abs(r) <= 2*ray :
		return true
	return false
func get_neighboor_coords(coord) :
	var ul = get_coord_ul(coord[0], coord[1])
	var ur = get_coord_ur(coord[0], coord[1])
	var l = get_coord_l(coord[0], coord[1])
	var r = get_coord_r(coord[0], coord[1])
	var dl = get_coord_dl(coord[0], coord[1])
	var dr = get_coord_dr(coord[0], coord[1])
	var neighboor_coords = []
	for c in [ul, ur, l, r, dl, dr] :
		if verify_coords_in_map(c) :
			neighboor_coords += [c]
	return neighboor_coords

func get_ind_grid_from_coord(coord) :
	var j = coord[1] + ray
	var i
	if coord[1] <= 0 :
		i = coord[0] + ray + coord[1]
	else :
		i = coord[0] + ray
	return [i, j]

func find_best_path(c1, c2, mc) :
	var flags_grid = [] #flag de passage
	for line in grid :
		var new_line = []
		for i in range(len(line)) :
			new_line += [false]
		flags_grid += [new_line]
			
	var queue = []
	var current_coord = null
	var dist_cc = null
	var path = null
	queue.append([c1, 0, []]) #init
	
	while len(queue) != 0:
		#extraction
		var tmp = queue.pop_front()
		current_coord = tmp[0]
		dist_cc = tmp[1]
		path = tmp[2]
		if current_coord == c2 : #path found
			path += [c2]
			return path
		
		var ind = get_ind_grid_from_coord(current_coord)
		if flags_grid[ind[1]][ind[0]] : 
			continue #cell déjà parcouru
		else :
			flags_grid[ind[1]][ind[0]] = true #on marque la cell
		if grid[ind[1]][ind[0]][1] != "flor" :
			continue #cell imparcourable
			
		if dist_cc < mc : #or we are too far from c1
			var neighboors = get_neighboor_coords(current_coord)
			for n in neighboors :
				queue.append([n, dist_cc + 1, path + [current_coord]])
	
func get_cell_node_from_coord(coord) :
	var name = 'Cell_' + str(coord[0]) + '_' + str(coord[1])
	return get_node(name)
		
func _ready():
	pass

func _process(delta) :
#	var node = get_cell_node_from_coord(cursor_cell_location)
#	if node and node.is_empty :
#		$Ninja.position.x = node.position.x
#		$Ninja.position.y = node.position.y
#		$Ninja.visible = true
#		node.is_empty = false
	pass
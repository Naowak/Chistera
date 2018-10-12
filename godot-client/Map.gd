extends Node2D

var Cell = preload("res://Cell.tscn")

var last_cell_selected_coord = [null, null]

var cpt = 0
var tab_cells = []

var q #x
var r #y

func create_one_cell(posx, posy) :
	var c = Cell.instance()
	c.position.x = posx
	c.position.y = posy
	c.set_name("Cell_" + str(cpt))
	tab_cells += [[q, r]]
	cpt = cpt + 1
	add_child(c)
	return c
func get_pos_cell_dr(pos) :
	return [pos[0] + 35, pos[1] + 38]
func get_pos_cell_dl(pos) :
	return [pos[0] - 35, pos[1] + 38]
func get_pos_cell_r(pos) :
	return [pos[0] + 70, pos[1]]
func draw_one_line(pos_begin, nb_cell) :
	var pos = [pos_begin[0], pos_begin[1]]
	for i in range(nb_cell) :
		var c = create_one_cell(pos[0], pos[1])
		c.q = q
		c.r = r
		c.get_node("Label").text = str(q) + " / " + str(r)
		q += 1
		pos = get_pos_cell_r(pos)
func create_map(ray, pos_begin) :
	var nb_cell = ray + 1
	q = 0
	r = -ray
	for i in range(ray) :
		draw_one_line(pos_begin, nb_cell)
		pos_begin = get_pos_cell_dl(pos_begin)
		nb_cell += 1
		r += 1
		q = -ray -r
	for i in range(ray + 1) :
		draw_one_line(pos_begin, nb_cell)
		r += 1
		q = - ray
		pos_begin = get_pos_cell_dr(pos_begin)
		nb_cell -= 1

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
	if abs(s) + abs(q) + abs(r) <= 6 :
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

func get_cell_node_from_coord(coord) :
	var q = coord[0]
	var r = coord[1]
	var cmp = 0
	for iter in tab_cells :
		var s = iter[0]
		var t = iter[1]
		if q == s and r == t :
			var name = "Cell_" + str(cmp)
			return get_node(name)
		cmp += 1
		
func _ready():
	#create_map(5, [400, 150])
	#create_ninja()
	pass

func _process(delta) :
#	var node = get_cell_node_from_coord(cursor_cell_location)
#	if node and node.is_empty :
#		$Ninja.position.x = node.position.x
#		$Ninja.position.y = node.position.y
#		$Ninja.visible = true
#		node.is_empty = false
	pass
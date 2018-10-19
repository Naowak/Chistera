extends Node2D

var Character_class = preload("res://Character.tscn")

var is_on_battle = false
var on_step = "not_begin"
var state = null

func on_msg(data) :
	if not "step" in data :
		print("Error BattleScreen on_msg have no step")
		return
	on_step = data["step"]
	if on_step == "new_game" :
		new_game(data)

func update(data) :
	if data["step"] == "coords_begin" :
		pass 

#modifier avec l'arrivé des team !
func create_character(name, cell) :
	var character = Character_class.instance()
	var hero_position = [cell.position.x, cell.position.y]
	character.create_hero(name, hero_position)
	character.set_name(name)
	add_child(character)

func on_cell_selected(cell) :
	var cell_flor = get_tree().get_nodes_in_group("cell_flor")
	for c in cell_flor :
		c.animation = "normal"
		c.get_node("Label").visible = false
	var c1 = [0, 0]
	var c2 = [cell.q, cell.r]
	var path = $Map.find_best_path(c1, c2, 10)
	if path :
		var cpt = 0
		for coord in path :
			var c = $Map.get_cell_node_from_coord(coord)
			c.animation = "white"
			c.get_node("Label").visible = true
			c.get_node("Label").text = str(cpt)
			cpt += 1

func new_game(data) :
	is_on_battle = true
	var grid = data["grid"]
	var state = data["state"]
	$Map.create_map_from_grid(grid)
	for hero in state["team"] :
		var cell_spawn = $Map.get_cell_node_from_coord(hero["coord"])
		create_character(hero["name"], cell_spawn)

func _ready():
	pass

func ask_to_play(team):
	var dict = {}
	dict["step"] = "ask_to_play"
	dict["team"] = team
	get_tree().get_root().get_node("Jeu/Network").sendMessage(dict)

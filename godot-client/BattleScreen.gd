extends Node2D

var Ninja = preload("res://Ninja.tscn")
var Zombie = preload("res://Zombie.tscn")

var is_on_battle = false

func on_msg(data) :
	if not "step" in data :
		print("Error BattleScreen on_msg have no step")
	if data["step"] == "new_game" :
		new_game(data)

func create_character(cell, name) :
	var character
	if name == "Ninja" :
		character = Ninja.instance()
	elif name == "Zombie" :
		character = Zombie.instance()
	character.scale.x = 0.15
	character.scale.y = 0.15
	character.position.x = cell.position.x
	character.position.y = cell.position.y
	character.visible = true
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
		create_character(cell_spawn, hero["name"])
	

func _ready():
	pass

func ask_to_play(team):
	var dict = {}
	dict["step"] = "ask_to_play"
	dict["team"] = team
	get_tree().get_root().get_node("Jeu/Network").sendMessage(dict)

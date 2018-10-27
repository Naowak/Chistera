extends Node2D

var Character_class = preload("res://Character.tscn")
var StepCellsStart = preload("res://StepCellsStart.tscn")
var StepPlayTurn = preload("res://StepPlayTurn.tscn")

var network = null 

var is_on_battle = false
var battle_gid = null
var on_step = "not_begin"


func on_msg(data) :
	if not "step" in data :
		print("Error BattleScreen on_msg have no step")
		return
	if "error" in data :
		if len(data["error"]) > 0 :
			print(data["error"])
			return
		
	if data["step"] == "ask_to_play" :
		if data["action"]["name"] == "wait" :
			$MessageWait.visible = true
			on_step = "ask_to_play"
			
	elif data["step"] == "new_game" :
		$MessageWait.visible = false
		on_step = "new_game"
		new_game(data)
		
	elif data["step"] == "coords_begin" :
		if data["action"]["name"] == "give_coords_begin" :
			var scs = StepCellsStart.instance()
			add_child(scs)
			scs.start(data)
	
	elif data["step"] == "on_turn" : 
		if data["action"]["name"] == "new_turn" :
			print("coucou")
			var spt = StepPlayTurn.instance()
			add_child(spt)
			spt.start(data)
			
func pass_turn() :
	var msg = {"step" : on_step, 
		"action" : {"name" : "pass_turn"}}
	network.sendMessage(msg)

#modifier avec l'arrivé des team !
func create_character(name, cell) :
	var character = Character_class.instance()
	character.create_hero(name, cell)
	character.set_name(name)
	add_child(character)
	
func get_character(name) :
	return get_node(name)

func on_cell_selected(cell) :
#	var cell_flor = get_tree().get_nodes_in_group("cell_flor")
#	for c in cell_flor :
#		c.animation = "normal"
#		c.get_node("Label").visible = false
#	var c1 = [0, 0]
#	var c2 = [cell.q, cell.r]
#	var path = $Map.find_best_path(c1, c2, 10)
#	if path :
#		var cpt = 0
#		for coord in path :
#			var c = $Map.get_cell_node_from_coord(coord)
#			c.animation = "white"
#			c.get_node("Label").visible = true
#			c.get_node("Label").text = str(cpt)
#			cpt += 1
	if on_step == "coords_begin" :
		$StepCellsStart.on_cell_selected(cell)
	elif on_step == "on_turn" :
		$StepPlayTurn.on_cell_selected(cell)
	else :
		print("Error Step NotKnown : " + on_step + " : cells_selected Battlescreen")

func on_character_selected(character) :
	if on_step == "coords_begin" :
		$StepCellsStart.on_character_selected(character)
	else :
		print("Error Step Not Known : character_selected Battlescreen")
	
func new_game(data) :
	is_on_battle = true
	battle_gid = data["gid"]
	var grid = data["grid"]
	var state = data["state"]
	$Map.create_map_from_grid(grid)
	for hero in state["team"] :
		var cell_spawn = $Map.get_cell_node_from_coord(hero["coord"])
		create_character(hero["name"], cell_spawn)
	var ans_data = {"step" : "new_game", "action" : { "name" : "ready"}}
	network.sendMessage(ans_data)

func _ready():
	network = get_tree().get_root().get_node("Jeu/Network")



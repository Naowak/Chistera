extends Node2D

var Character_class = preload("res://Character.tscn")
var StepCellsStart = preload("res://StepCellsStart.tscn")

var network = null 

var is_on_battle = false
var battle_gid = null
var on_step = "not_begin"


func on_msg(data) :
	if not "step" in data :
		print("Error BattleScreen on_msg have no step")
		return
	on_step = data["step"]
	if "error" in data :
		print(data["error"])
		return
		
	if on_step == "ask_to_play" :
		if data["action"]["name"] == "wait" :
			$MessageWait.visible = true
			
	elif on_step == "new_game" :
		$MessageWait.visible = false
		new_game(data)
		
	elif on_step == "coords_begin" :
		if data["action"]["name"] == "give_coords_begin" :
			var scs = StepCellsStart.instance()
			add_child(scs)
			scs.start(data["action"]["coords"], data["action"]["time_one_turn"])
			


#modifier avec l'arrivé des team !
func create_character(name, cell) :
	var character = Character_class.instance()
	character.create_hero(name, cell)
	character.set_name(name)
	add_child(character)

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
	else :
		print("Error Step NotKnown : " + on_step + " : cells_selected Battlescreen")

func on_character_selected(character) :
	if on_step == "coords_begin" :
		$StepCellsStart.on_character_selected(character)
	else :
		print("Error Step Not Known : character_selected Battlescreen")
	
#func end_StepCellsStart() :
#	actual_scene = null

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



extends Node2D

var jeu = null
var battlescreen = null 
var map = null
var coords_begin = null

var character_selected = null

func on_msg(data) :
	if not "step" in data :
		print("Error stepcellsstart on_msg have no step")
		return
	if len(data["error"]) > 0 :
		print(data["error"])
		return
	if data["step"] == "coords_begin" :
		if data["action"]["name"] == "move_character" :
			var character = battlescreen.get_node(data["action"]["character"])
			var cell = map.get_cell_node_from_coord(data["action"]["coord"])
			character.set_on_cell(cell)
	if data["step"] == "on_turn" :
		close()
		battlescreen.on_msg(data)
	else :
		print("Step not known : stepcellsstart")

func start(data) :
	coords_begin = data["action"]["coords"]
	for coord in coords_begin :
		var cell = map.get_cell_node_from_coord(coord)
		cell.animation = "blue"
	$Timer.wait_time = data["action"]["time_one_turn"]
	$Timer.start()
	jeu.change_receiver("BattleScreen/StepCellsStart")
	battlescreen.on_step = "coords_begin"

func close() :
	for coord in coords_begin :
		var cell = map.get_cell_node_from_coord(coord)
		cell.animation = "normal"
	jeu.change_receiver("BattleScreen")

func on_character_selected(character) :
	character_selected = character
		
func on_cell_selected(cell) :
	if character_selected :
		if cell.is_empty :
			var coord = [cell.q, cell.r]
			var data = {"step" : "coords_begin",
				"gid" : battlescreen.battle_gid,
				"action" : { "name" : "move_character",
					"character" : character_selected.NAME,
					"coord" : coord}
				}
			var network = get_tree().get_root().get_node("Jeu/Network")
			network.sendMessage(data)
		else :
			character_selected = cell.character
	else :
		if not cell.is_empty :
			character_selected = cell.character

func _ready() :
	jeu = get_tree().get_root().get_node("Jeu")
	battlescreen = jeu.get_node("BattleScreen")
	map = battlescreen.get_node("Map")

func _on_Timer_timeout():
	close()

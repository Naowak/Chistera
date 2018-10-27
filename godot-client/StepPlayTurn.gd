extends Node2D

var jeu = null
var battlescreen = null 
var map = null

var on_character = null
var on_player = null

func on_msg(data) :
	if not "step" in data :
		print("Error stepcellsstart on_msg have no step")
		return
	if len(data["error"]) > 0 :
		print(data["error"])
		return
	
	if data["step"] == "on_turn" :
		if data["action"]["name"] == "new_turn" :
				start(data)
	
	else :
		print("Step not known : stepplayturn")

func start(data) :
	$Timer.wait_time = data["action"]["time_one_turn"]
	$Timer.start()
	jeu.change_receiver("BattleScreen/StepPlayTurn")
	on_player = data["on_player"]
	on_character = battlescreen.get_character(data["on_character"])
	battlescreen.on_step = "on_turn"

func close() :
	jeu.change_receiver("BattleScreen")

func on_character_selected(character) :
	pass
		
func on_cell_selected(cell) :
	cell.animation = "white"
	

func _ready() :
	jeu = get_tree().get_root().get_node("Jeu")
	battlescreen = jeu.get_node("BattleScreen")
	map = battlescreen.get_node("Map")

func _on_Timer_timeout():
	close()
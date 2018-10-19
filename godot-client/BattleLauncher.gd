extends Node2D

var team = []
var team_len_max = 1

func character_selected(name) :
	if not name in team :
		var node_c = get_node(name + "Icon")
		var node_cb = node_c.get_node("CheckButton")
		if not node_cb.pressed :
			node_cb.pressed = true
		team += [name]
		if len(team) > team_len_max :
			var character_out = team.pop_front()
			get_node(character_out + "Icon" + "/CheckButton").pressed = false

func character_unselected(name) :
	team.erase(name)
	get_node(name + "Icon" + "/CheckButton").pressed = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_ButtonStart_pressed():
	if len(team) == team_len_max :
		var node_jeu = get_tree().get_root().get_node("Jeu")
		node_jeu.get_node("BattleScreen").ask_to_play(team)
		node_jeu.new_screen = "BattleScreen"
		
	

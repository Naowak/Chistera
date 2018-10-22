extends Node2D

var network = null
var team = []
var team_len_max = 2

func on_msg(data) :
	print("Msg recv on BattleLauncher")

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
	
func ask_to_play(team):
	var dict = {}
	dict["step"] = "ask_to_play"
	dict["team"] = team
	network.sendMessage(dict)

func _ready():
	network = get_tree().get_root().get_node("Jeu/Network")

func _on_ButtonStart_pressed():
	if len(team) == team_len_max :
		var node_jeu = get_tree().get_root().get_node("Jeu")
		ask_to_play(team)
		node_jeu.change_receiver("BattleScreen")
		node_jeu.change_screen("BattleScreen")
		
	

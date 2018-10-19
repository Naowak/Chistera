extends Node2D

#pour changer de scene, il suffit de changer new_screen
var screen = "Menu"
var new_screen = "Menu"

func _ready():
	$Menu.visible = true
	$BattleScreen.visible = false

func _process(delta):
	if screen != new_screen :
		var ns = get_tree().get_root().get_node("Jeu/" + new_screen)
		var os = get_tree().get_root().get_node("Jeu/" + screen)
		os.visible = false
		ns.visible = true
		screen = new_screen

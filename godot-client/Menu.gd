extends Node2D

#change the value of new_screen to change the screen menu
var screen = "Launcher"
var new_screen = "Launcher"

func _ready():
	$Launcher.visible = true
	$BattleLauncher.visible = false

func _process(delta) :
	if screen != new_screen :
		var ns = get_tree().get_root().get_node("Jeu/Menu/" + new_screen)
		var os = get_tree().get_root().get_node("Jeu/Menu/" + screen)
		os.visible = false
		ns.visible = true
		screen = new_screen
		
		
		
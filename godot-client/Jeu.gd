extends Node2D

var screen = "Menu/Launcher"
var node_receiver = null
var background_color = Color(0.3, 0.3, 0.3)

func change_screen(new_screen) :
	if screen != new_screen :
		var ns = get_tree().get_root().get_node("Jeu/" + new_screen)
		var os = get_tree().get_root().get_node("Jeu/" + screen)
		os.visible = false
		ns.visible = true
		screen = new_screen

func change_receiver(new_receiver) :
	var nr = get_tree().get_root().get_node("Jeu/" + new_receiver)
	node_receiver = nr

func _ready():
	$Menu/Launcher.visible = true
	$Menu/BattleLauncher.visible = false
	$BattleScreen.visible = false

func _process(delta):
	pass

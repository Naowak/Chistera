extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func _on_ButtonConnect_pressed():
	var pseudo = get_tree().get_root().get_node("Jeu/Menu/Launcher/LineEditPseudo").text
	get_tree().get_root().get_node("Jeu/Network").connect(pseudo)
	get_tree().get_root().get_node("Jeu/Menu").new_screen = "BattleLauncher"

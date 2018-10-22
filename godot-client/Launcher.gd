extends Node2D

func on_msg(data) :
	print("Message recv on Launcher")

func _ready():
	pass

func _on_ButtonConnect_pressed():
	var jeu = get_tree().get_root().get_node("Jeu")
	var pseudo = jeu.get_node("Menu/Launcher/LineEditPseudo").text
	jeu.get_node("Network").connect(pseudo)
	jeu.change_receiver("Menu/BattleLauncher")
	jeu.change_screen("Menu/BattleLauncher")
	

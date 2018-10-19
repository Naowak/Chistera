extends AnimatedSprite

var NAME = "Zombie"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_CheckButton_pressed():
	var node_jeu = get_tree().get_root().get_node("Jeu")
	var nbl = get_tree().get_root().get_node("Jeu/Menu/BattleLauncher")
	if $CheckButton.pressed :
		nbl.character_selected(NAME)
	else :
		nbl.character_unselected(NAME)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton :
		if event.button_index == BUTTON_LEFT and event.pressed :
			var node_jeu = get_tree().get_root().get_node("Jeu")
			var node_bl = node_jeu.get_node("Menu/BattleLauncher")
			if NAME in node_bl.team :
				node_bl.character_unselected(NAME)
			else :
				node_bl.character_selected(NAME)
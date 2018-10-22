extends AnimatedSprite

var q = 0
var r = 0

var is_empty = true
var character = null

func fill_character(c) :
	if is_empty :
		is_empty = false
		character = c

func remove_character() :
	is_empty = true
	character = null
	

func _ready() :
	add_to_group("cell_flor")

func _process(delta):
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	var gs = get_tree().get_root().get_node("Jeu/BattleScreen")
	if event is InputEventMouseButton :
		if event.button_index == BUTTON_LEFT and event.pressed :
			gs.on_cell_selected(self)
			
	

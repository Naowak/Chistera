extends AnimatedSprite

export var q = 0
export var r = 0

var is_empty = true
var animations = ["normal", "white"]

func _ready() :
	scale.x = 0.2
	scale.y = 0.2

func _process(delta):
#	var tmp = get_tree().get_root().get_node("GameScreen/Map").last_cell_selected_coord
#	if tmp[0] == q and tmp[1] == r :
#		animation = "white"
#	else :
#		animation = "normal"
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton :
		if event.button_index == BUTTON_LEFT :
			var map = get_tree().get_root().get_node("GameScreen/Map")
			var old_cell_selected = map.get_cell_node_from_coord(map.last_cell_selected_coord)
			if old_cell_selected :
				old_cell_selected.is_empty = true
			map.last_cell_selected_coord = [q, r]
			is_empty = false

			
	

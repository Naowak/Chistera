extends Node2D

var battlescreen = null

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var rect
var color 

func _draw():
	draw_rect(rect,color)

func _ready():
	battlescreen = get_tree().get_root().get_node("Jeu/BattleScreen")
	color = Color(0.2, 0.2, 0.2)
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	rect = Rect2(Vector2(width*3/4, 0), Vector2(width, height))
	update()

func _process(delta) :
	if battlescreen.on_step == "coords_begin" :
		$LabelTime.text = str(int(battlescreen.get_node("StepCellsStart/Timer").time_left))
	if battlescreen.on_step == "on_turn" :
		$LabelTime.text = str(int(battlescreen.get_node("StepPlayTurn/Timer").time_left))
#	elif node_bs.on_step == "on_turn" :
#		$LabelTime.text = str(int(node_bs.get_node("StepTurn/Timer").time_left))

func _on_ButtonPassTurn_pressed():
	battlescreen.pass_turn()

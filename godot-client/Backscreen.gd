extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var rect
var color 

func _draw():
	draw_rect(rect,color)

func _ready():
	color = get_tree().get_root().get_node("Jeu").background_color
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	rect = Rect2(Vector2(0, 0), Vector2(width, height))
	update()

extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var rect
var color 

func _draw():
	draw_rect(rect,color)

func _ready():
	color = Color(0.2, 0.2, 0.2)
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	rect = Rect2(Vector2(width*3/4, 0), Vector2(width, height))
	update()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

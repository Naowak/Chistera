extends Node2D

var Ninja = preload("res://Ninja.tscn")

func create_ninja() :
	var nin = Ninja.instance()
	nin.scale.x = 0.15
	nin.scale.y = 0.15
	nin.position.x = 500
	nin.position.y = 500
	nin.visible = true
	add_child(nin)

func _ready():
	create_map(ray, map_anchor)
	create_ninja()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

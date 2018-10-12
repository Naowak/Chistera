extends Node2D

var Ninja = preload("res://Ninja.tscn")

func create_ninja(posx, posy) :
	var nin = Ninja.instance()
	nin.scale.x = 0.15
	nin.scale.y = 0.15
	nin.position.x = posx
	nin.position.y = posy
	nin.visible = true
	add_child(nin)

func new_game(data) :
#	var ray = data["ray"]
#	var map_anchor = data["map_anchor"]
#	var coord_ninja = data["coord_ninja"]
#	$Map.create_map(ray, map_anchor)
#	var cell = $Map.get_cell_node_from_coord(coord_ninja)
#	create_ninja(cell.position.x, cell.position.y)
	var grid = data["grid"]
	var pos_center = data["pos_center"]
	$Map.create_map_from_grid(grid, pos_center)

func _ready():
#	var msg = {"action" : "new_game", 
#				"map_anchor" : [150, 200], 
#				"ray" : 6, 
#				"coord_ninja" : [0, 0]}
#	new_game(msg)
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_GameLauncher_pressed():
	var dict = {}
	dict["action"] = "new_game"
	dict["pseudo"] = $EditPseudo.text
	$Network.sendMessage(dict)

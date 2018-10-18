extends Node2D

var Ninja = preload("res://Ninja.tscn")

func create_ninja(cell) :
	var nin = Ninja.instance()
	nin.scale.x = 0.10
	nin.scale.y = 0.10
	nin.position.x = cell.position.x
	nin.position.y = cell.position.y
	nin.visible = true
	add_child(nin)

func on_cell_selected(cell) :
	var cell_flor = get_tree().get_nodes_in_group("cell_flor")
	for c in cell_flor :
		c.animation = "normal"
		c.get_node("Label").visible = false
	var c1 = [0, 0]
	var c2 = [cell.q, cell.r]
	var path = $Map.find_best_path(c1, c2, 10)
	if path :
		var cpt = 0
		for coord in path :
			var c = $Map.get_cell_node_from_coord(coord)
			c.animation = "white"
			c.get_node("Label").visible = true
			c.get_node("Label").text = str(cpt)
			cpt += 1

func new_game(data) :
	var grid = data["grid"]
	var state = data["state"]
	$Map.create_map_from_grid(grid)
	for hero in state["team"] :
		var cell_spawn = $Map.get_cell_node_from_coord(hero["coord"])
		if hero["name"] == "Ninja" :
			create_ninja(cell_spawn)
	

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
	dict["action"] = "ask_to_play"
	dict["team"] = ["Ninja"]
	$Network.sendMessage(dict)

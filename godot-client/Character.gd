extends Node2D

var Ninja = preload("Ninja.tscn")
var Zombie = preload("Zombie.tscn")

var position_last_motion


var NAME = ""
var max_lp
var max_mana
var max_mp
var lp
var mana
var mp
var coord

func create_hero(name, cell) :
	NAME = name
	var hero
	if name == "Ninja" :
		hero = Ninja.instance()
	elif name == "Zombie" :
		hero = Zombie.instance()
	else :
		print("Name isn't defined for any hero.")
		return
	set_on_cell(cell)
	hero.scale.x = 0.15
	hero.scale.y = 0.15
	add_child(hero)
	extract_features(name)
	get_node("HeadingChar/labelname").text = NAME
	get_node("HeadingChar/labellife").text = str(lp)
	get_node("HeadingChar/labelmana").text = str(mana)
	get_node("HeadingChar/labelmp").text = str(mp)

func extract_features(name) :
	var file = File.new()
	file.open("res://character_features/" + name, file.READ)
	var filetext = file.get_as_text()
	for line in filetext.split("\n") :
		var tmp = line.split(" = ")
		if tmp[0] == "name" :
			NAME = tmp[1]
		elif tmp[0] == "lp_max" :
			max_lp = int(tmp[1])
			lp = max_lp
		elif tmp[0] == "mana_max" :
			max_mana = int(tmp[1])
			mana = max_mana
		elif tmp[0] == "mp_max" :
			max_mp = int(tmp[1])
			mp = max_mp

func set_on_cell(cell) :
	#libère l'ancienne cell et ajoute à la nouvelle
	if coord :
		var oc = get_tree().get_root().get_node("Jeu/BattleScreen/Map").get_cell_node_from_coord(coord)
		oc.remove_character()
	position.x = cell.position.x
	position.y = cell.position.y - 5
	coord = [cell.q, cell.r]
	cell.fill_character(self)

func _ready() :
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		if $HeadingChar/Timer.time_left == 0 :
			$HeadingChar.visible = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	var bs = get_tree().get_root().get_node("Jeu/BattleScreen")
	if event is InputEventMouseMotion :
		$HeadingChar.visible = true
		$HeadingChar/Timer.start()
	elif event is InputEventMouseButton :
		if event.button_index == BUTTON_LEFT :
			bs.on_character_selected(self)

func _process(delta) :
	pass

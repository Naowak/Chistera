extends AnimatedSprite

var NAME = "Zombie"
var max_lp = 800
var max_mana = 100
var max_mp = 2
var lp = max_lp
var mana = max_mana
var mp = max_mp


func _ready() :
	$entete/labelname.text = NAME
	$entete/labellife.text = str(lp)
	$entete/labelmana.text = str(mana)
	$entete/labelmp.text = str(mp)
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	var gs = get_tree().get_root().get_node("Jeu/BattleScreen")
	if event is InputEventMouseMotion :
		$entete.visible = true
		$entete/Timer.start()
	if event is InputEventMouseButton :
		if event.button_index == BUTTON_LEFT :
			gs.on_character_selected(self)

func _process(delta) :
	pass


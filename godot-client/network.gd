extends Node

# instance
var websocket
var is_connected = false
var pseudo_server

func decode(mess) :
	return str2var(mess)

func encode(mess) :
	return var2str(mess)
	
# handler to text messages
func _on_message(msg):
	var data = decode(msg)
	print(data["step"])
#	print("Message reçu : ", str(data))
	var nj = get_tree().get_root().get_node("Jeu")
#	nj.get_node(nj.screen).on_msg(data)
	nj.node_receiver.on_msg(data)
	

func sendMessage(msg) :
	var battlescreen = get_tree().get_root().get_node("Jeu/BattleScreen")
	if battlescreen.is_on_battle :
		msg["gid"] = battlescreen.battle_gid
	var mess = encode(msg)
	websocket.send(mess)

func connect(pseudo) :
	websocket = preload('websocket/websocket.gd').new(self)
	websocket.connect('localhost',8000)
	websocket.set_receiver(self,'_on_message')
	var data = {}
	data["step"] = "connexion"
	data["pseudo"] = pseudo
	var pseudo_server = pseudo
	sendMessage(data)
	is_connected = true
# handler to some button on you scene
#func _on_some_button_released():
#	websocket.send("Some short message here")

# entry point
func _ready():
	pass

func _process(delta):
	if is_connected :
		websocket.listen()

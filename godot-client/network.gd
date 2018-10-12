extends Node

# instance
var websocket

func decode(mess) :
	return str2var(mess)

func encode(mess) :
	return var2str(mess)
	
# handler to text messages
func _on_message(msg):
	var data = decode(msg)
	print("Message reçu : ", str(data))
	if data["action"] == "new_game" :
		var gamescreen = get_tree().get_root().get_node("GameScreen")
		gamescreen.new_game(data)

func sendMessage(msg) :
	var mess = encode(msg)
	websocket.send(mess)

# handler to some button on you scene
#func _on_some_button_released():
#	websocket.send("Some short message here")

# entry point
func _ready():
	websocket = preload('websocket/websocket.gd').new(self)
	websocket.connect('localhost',8000)
	websocket.set_receiver(self,'_on_message')

func _process(delta):
	websocket.listen()

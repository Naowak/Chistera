extends Node

# instance
var websocket

func decode(mess) :
	return str2var(mess)

func encode(mess) :
	return var2str(mess)
	
# handler to text messages
func _on_message(msg):
	var d = decode(msg)
	print("Message reçu : ", str(d))
	if "coord_q" in d and "coord_r" in d :
		pass

# handler to some button on you scene
#func _on_some_button_released():
#	websocket.send("Some short message here")

# entry point
func _ready():
	websocket = preload('websocket/websocket.gd').new(self)
	websocket.start('localhost',8000)
	websocket.set_receiver(self,'_on_message')
	var dict = {"mon" : 6, "hello" : 8}
	var mess = encode(dict)
	websocket.send(mess)

func _process(delta):
	websocket.run()

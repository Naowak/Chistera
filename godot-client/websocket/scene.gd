extends Node

var websocket
var run_time = 0

func _process(delta):
	run_time += delta
	get_node("time").set_text(str(run_time).pad_decimals(2))
	websocket.run()

func _ready():
	websocket = preload('websocket.gd').new(self)
	websocket.start('godot-websocket-tutorial-marcosbitetti.c9users.io',3000)  # Replace with site:port for your node.js script
	websocket.set_receiver(self,'_on_message_received')

func _on_message_received(msg):
	print(msg)

func _on_Button_pressed():
	websocket.send("Hi server")

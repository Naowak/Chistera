extends Node

var websocket
var error

func _process(delta):
	if !error: error = websocket.listen()

func _ready():
	websocket = preload('websocket.gd').new(null)
	error = websocket.connect('example.com',3000)
	if error: print(error)
	websocket.set_receiver(self,'_on_message_received')

func _on_message_received(msg):
	print(msg)

func _on_Button_pressed():
	websocket.send("abcdefGHIJKLmnopQRTSuvwXYZ123l;agoi]h3f9pa382hfo328r3ov8rwe;osylfsd;oigslhfmlg;dfahfdlghfrdgprtuohg5iohgregklaafaw567890123456789")

extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var a = {"send":"ok", "commo" : 23, "co" : {"ed" : 45, "p" : "cp"}}
	var b = var2str(a)
	var c = str2var(b)
	print(b)
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

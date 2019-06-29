extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var r = int(rad2deg(rotation))%360
	if(r<0):
		r+=360
	if(r>180):
		z_index = 0
	else:
		z_index = 2
	if(r>270 or r < 90):
		flip_v = false
	else:
		flip_v = true
	print(r)
#	pass

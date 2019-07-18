extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var r = int(rad2deg(rotation))%360
	if(r<0):
		r+=360
	if(r>180):
		$HandSprite.z_index = 0
	else:
		$HandSprite.z_index = 2
	if(r>270 or r < 90):
		$HandSprite.flip_v = false
	else:
		$HandSprite.flip_v = true


func shoot():
	$Explosion.play()
	var r = int(rad2deg(rotation))%360
	if(r<0):
		r+=360
	if(r>270 or r < 90):
		$AnimationPlayer.play("shoot")
	else:
		$AnimationPlayer.play("shoot_rev")

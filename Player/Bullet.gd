extends KinematicBody2D

class_name Bullet

export var speed : int = 300

var direction : Vector2
var veloctity : Vector2

func _physics_process(delta):
	veloctity = direction*speed*delta
	move_and_collide(veloctity)
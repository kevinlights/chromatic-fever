extends KinematicBody2D

class_name Enemy

signal screen_freeze(duration)
signal screen_shake(duration)

export var acceleration : int = 300
export var deceleration : int = 300
export var top_speed : int = 100
export var max_health : int = 3

onready var player : KinematicBody2D = get_node("/root/Game/Player")
onready var health : int = max_health

#Movement
var direction : Vector2 
var velocity : Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$LesSprites/AnimationPlayer.play("marche")
	pass # Replace with function body.

func _physics_process(delta):
	direction = Vector2()
	
	direction = movement_oracle()
	
	velocity = top_speed*direction
	
	move_and_slide(velocity,Vector2.UP)
	#look_at(player.global_position)

func movement_oracle() -> Vector2:
	return (player.global_position - global_position).normalized()
	
func hit():
	health -= 1
	if health <= 0:
		die()
	emit_signal("screen_freeze",1)
	emit_signal("screen_shake",0.8)

func die():
	get_parent().remove_child(self)
extends KinematicBody2D

class_name Enemy

signal screen_freeze(duration)
signal screen_shake(duration)

export var acceleration : int = 300
export var deceleration : int = 300
export var top_speed : int = 200
export var max_health : int = 3

onready var player : KinematicBody2D = get_node("/root/Game/Player")
onready var health : int = max_health

#Movement
var accel_direction : Vector2 
var decel_direction : Vector2
var velocity : Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	accel_direction = Vector2()
	decel_direction = Vector2()
	
	accel_direction = movement_oracle()
	
	if accel_direction.x == 0:
		decel_direction.x = (velocity.normalized()*-1).x
	if accel_direction.y == 0:
		decel_direction.y = (velocity.normalized()*-1).y
	
	velocity += acceleration*accel_direction.normalized()*delta
	velocity += deceleration*decel_direction.normalized()*delta
	
	var top_directional_speed : Vector2 = velocity.normalized()*top_speed
	velocity.x = clamp(velocity.x,0 if decel_direction.x < 0 else -abs(top_directional_speed.x),0 if decel_direction.x > 0 else abs(top_directional_speed.x))
	velocity.y = clamp(velocity.y,0 if decel_direction.y < 0 else -abs(top_directional_speed.y),0 if decel_direction.y > 0 else abs(top_directional_speed.y))
	
	#move_and_slide(velocity,Vector2.UP)
	look_at(player.global_position)

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
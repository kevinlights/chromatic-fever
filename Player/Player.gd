extends KinematicBody2D

signal player_hit()
signal player_die()

export var acceleration : int = 300
export var deceleration : int = 300
export var top_speed : int = 200
export var max_health : int = 1

#Movement
var accel_direction : Vector2 
var decel_direction : Vector2
var velocity : Vector2 = Vector2()

#Attributes
var health : int = max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	accel_direction = Vector2()
	decel_direction = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		accel_direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		accel_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		accel_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		accel_direction += Vector2.RIGHT
	
	if accel_direction.x == 0:
		decel_direction.x = (velocity.normalized()*-1).x
	if accel_direction.y == 0:
		decel_direction.y = (velocity.normalized()*-1).y
	
	velocity += acceleration*accel_direction.normalized()*delta
	velocity += deceleration*decel_direction.normalized()*delta
	
	var top_directional_speed : Vector2 = velocity.normalized()*top_speed
	velocity.x = clamp(velocity.x,0 if decel_direction.x < 0 else -abs(top_directional_speed.x),0 if decel_direction.x > 0 else abs(top_directional_speed.x))
	velocity.y = clamp(velocity.y,0 if decel_direction.y < 0 else -abs(top_directional_speed.y),0 if decel_direction.y > 0 else abs(top_directional_speed.y))
	
	move_and_slide(velocity,Vector2.UP)
	look_at(get_global_mouse_position())
	
func hit():
	health -= 1
	if health <= 0:
		die()
	emit_signal("player_hit")
	
func die():
	get_parent().remove_child(self)
	emit_signal("player_die")
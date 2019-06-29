extends KinematicBody2D

signal player_hit()
signal player_die()

onready var projectiles : Node2D = get_node("/root/Game/Projectiles")

onready var projectile_ressource : Resource = load("res://Player/Projectile.tscn")

# Movement parameters
export var acceleration : int = 300
export var deceleration : int = 300
export var top_speed : int = 200

# Attributes vars
export var max_health : int = 1
export var firing_rate : float = 1

# Movement vars
var accel_direction : Vector2 
var decel_direction : Vector2
var velocity : Vector2 = Vector2()

# Attributes vars
var health : int = max_health

# State vars
var can_shoot : bool = true

# Timers
var projectile_timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_timer.set_one_shot(true)
	projectile_timer.set_wait_time(firing_rate)
	projectile_timer.connect("timeout",self,"_on_firing_rate_timeout")
	
	add_child(projectile_timer)

func _physics_process(delta):
	accel_direction = Vector2()
	decel_direction = Vector2()
	
	# Movement Inputs
	if Input.is_action_pressed("ui_up"):
		accel_direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		accel_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		accel_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		accel_direction += Vector2.RIGHT
	
	# Movements
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
	
	# Orientation
	look_at(get_global_mouse_position())
	
	# Shoot Inputs
	if Input.is_action_pressed("ui_shoot") and can_shoot:
		shoot()

func shoot():
	var projectile : Projectile = projectile_ressource.instance()
	projectile.position = $ProjectilesSpawnPosition.get_global_position()
	projectile.direction = get_global_mouse_position() - global_position
	projectiles.add_child(projectile)
	can_shoot = false
	projectile_timer.start()

func _on_firing_rate_timeout():
	can_shoot = true

func hit():
	health -= 1
	if health <= 0:
		die()
	emit_signal("player_hit")
	
func die():
	get_parent().remove_child(self)
	emit_signal("player_die")
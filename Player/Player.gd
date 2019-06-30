extends KinematicBody2D

signal player_hit()
signal player_die()

onready var projectiles : Node2D = get_node("/root/Game/Projectiles")

onready var projectile_ressource : Resource = load("res://Player/Projectile.tscn")
onready var peintures : Sprite = get_node("/root/Game/Paint/Sprite")

# Movement parameters
export var acceleration : int = 1200
export var deceleration : int = 1200
export var top_speed : int = 400
export var on_hit_speed : int = 800

# Attributes vars
export var max_health : int = 3
export var firing_rate : float = 0.25
export var invincibility_duration : float = 1.5

# Movement vars
var accel_direction : Vector2 
var decel_direction : Vector2
var velocity : Vector2 = Vector2()

# Attributes vars
var health : int = max_health

# State vars
var can_shoot : bool = true
var invincible : bool = false

# Timers
var projectile_timer : Timer = Timer.new()
var invincibility_timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_timer.set_one_shot(true)
	projectile_timer.set_wait_time(firing_rate)
	projectile_timer.connect("timeout",self,"_on_firing_rate_timeout")
	add_child(projectile_timer)
	
	invincibility_timer.set_one_shot(true)
	invincibility_timer.set_wait_time(invincibility_duration)
	invincibility_timer.connect("timeout",self,"_on_invincibility_timeout")
	add_child(invincibility_timer)
	
func _process(delta):
	var img = peintures.get_texture().get_data()
	img.lock()
	var c = img.get_pixel(position.x,position.y)
	img.unlock()
	if(c.r>0.6 and c.a>0.1):
		$LesSprites/heros_couleur.modulate = Color(1.0,0.0,0.0)
	elif(c.g>0.6 and c.a>0.1):
		$LesSprites/heros_couleur.modulate = Color(0.0,1.0,0.0)
	elif(c.b>0.6 and c.a>0.1):
		$LesSprites/heros_couleur.modulate = Color(0.0,0.0,1.0)
	else:
		$LesSprites/heros_couleur.modulate = Color(0.5,0.5,0.5)
	
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
	$Hand.look_at(get_global_mouse_position())
	
	# Shoot Inputs
	if Input.is_action_pressed("ui_shoot") and can_shoot:
		shoot()

func shoot():
	var projectile : Projectile = projectile_ressource.instance()
	projectile.position = $Hand/ProjectilesSpawnPosition.get_global_position()
	projectile.direction = (get_global_mouse_position() - global_position).normalized()
	projectiles.add_child(projectile)
	projectile.make_connections()
	can_shoot = false
	projectile_timer.start()
	$Hand.shoot()


func _on_firing_rate_timeout():
	can_shoot = true


func _on_invincibility_timeout():
	invincible = false

func hit(collision_normal : Vector2):
	if not invincible and health > 0:
		health -= 1
		if health <= 0:
			die()
		velocity = collision_normal.normalized()*on_hit_speed
		invincible = true
		invincibility_timer.start()
		emit_signal("player_hit")
	
func die():
	get_parent().remove_child(self)
	emit_signal("player_die")
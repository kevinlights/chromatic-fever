extends KinematicBody2D

signal player_hit()
signal player_die()

onready var projectiles : Node2D = get_node("/root/Game/Projectiles")

onready var projectile_ressource : Resource = load("res://Player/Projectile.tscn")
onready var peintures : Sprite = get_node("/root/Game/Paint/Sprite")
onready var effacements : Viewport = get_node("/root/Game/Paint/Viewport_effacements")
onready var enemies = get_node("/root/Game/Enemies")


onready var game = get_node("..")
onready var global = get_node("/root/Global")

# Movement parameters
export var acceleration : int = 1200
export var deceleration : int = 1200
export var top_speed : int = 400
export var on_hit_speed : int = 800
export var jauge_empty_delay : float = 10
export var max_jauge : int = 10

# Attributes vars
export var max_health : int = 3
var firing_rate : float = 0.75
export var invincibility_duration : float = 1.5

var jauges : Array = [0,0,0]
var colormap : Dictionary

# Movement vars
var accel_direction : Vector2
var decel_direction : Vector2
var velocity : Vector2 = Vector2()

var combo_map : Dictionary

# Attributes vars
var health : int = max_health
var on_color : int = -1

# State vars
var can_shoot : bool = true
var invincible : bool = false

# Timers
var projectile_timer : Timer = Timer.new()
var invincibility_timer : Timer = Timer.new()
var color_change_timer : Timer = Timer.new()
var jauge_empty_timer : Timer = Timer.new()

var time_surprise = 0
var i_surprise = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	combo_map = {game.COMBO.NONE : 0.45,
				game.COMBO.TAINTED : 0.4,
				game.COMBO.PIGMENTED : 0.35,
				game.COMBO.COLOURFUL : 0.3,
				game.COMBO.CHROMATIC : 0.2}
				
	firing_rate =combo_map[game.COMBO.NONE]
	projectile_timer.set_one_shot(true)
	projectile_timer.set_wait_time(firing_rate)
	projectile_timer.connect("timeout",self,"_on_firing_rate_timeout")
	add_child(projectile_timer)
	
	invincibility_timer.set_one_shot(true)
	invincibility_timer.set_wait_time(invincibility_duration)
	invincibility_timer.connect("timeout",self,"_on_invincibility_timeout")
	add_child(invincibility_timer)
	
	jauge_empty_timer.set_one_shot(true)
	jauge_empty_timer.set_wait_time(jauge_empty_delay)
	jauge_empty_timer.connect("timeout",self,"_on_jauge_empty_timeout")
	add_child(jauge_empty_timer)
	jauge_empty_timer.start()
	
	color_change_timer.set_wait_time(0.5)
	color_change_timer.connect("timeout",self,"_on_color_change")
	add_child(color_change_timer)
	color_change_timer.start()
	
	enemies.connect("enemy_died",self,"_on_kill")
	#$LesSprites/heros_couleur.modulate = Color(0.5,0.5,0.5)
	colormap = {global.colors[0] : 0, global.colors[1] : 1,global.colors[2] : 2}
	$AnimationPlayer.play("idle")

func _process(delta):
	if(OS.get_ticks_msec ( ) - time_surprise > 10000):
		$LesSprites/heros_face.visible = false
		$LesSprites/heros_face2.visible = false
		$LesSprites/heros_face3.visible = false
		i_surprise = i_surprise + 1
		if(i_surprise>2):
			i_surprise = 0
		if(i_surprise==0):
			$LesSprites/heros_face.visible = true
		elif(i_surprise==1):
			$LesSprites/heros_face2.visible = true
		elif(i_surprise==2):
			$LesSprites/heros_face3.visible = true
		time_surprise = OS.get_ticks_msec ( )
		print(i_surprise)
	if(!$AnimationPlayer.is_playing()):
			$AnimationPlayer.play("idle")

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
		
	firing_rate = combo_map[game.combo]

func shoot():
	var projectile : Projectile = projectile_ressource.instance()
	projectile.position = $Hand/ProjectilesSpawnPosition.get_global_position()
	projectile.direction = (get_global_mouse_position() - global_position).normalized()
	projectiles.add_child(projectile)
	projectile.make_connections()
	can_shoot = false
	projectile_timer.start()
	
	var soundToPlay = randi()%4+1

	match soundToPlay:
		1:
			$Sounds/shot1.play()
		2:
			$Sounds/shot2.play()
		3:
			$Sounds/shot3.play()
			
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
		$Sounds/oof.play()
		emit_signal("player_hit")
		$AnimationPlayer.play("hurt")
	
func die():
	hide()
	emit_signal("player_die")
	get_tree().paused = true
	
func _on_color_change():
	var img = peintures.get_texture().get_data()
	img.lock()
	var c = img.get_pixel(position.x+41*0.3,position.y+220*0.3)
	img.unlock()
	img = effacements.get_texture().get_data()
	img.lock()
	var e = img.get_pixel(position.x+41*0.3,position.y+220*0.3)
	img.unlock()
	if(c.r>0.6 and c.a>0.1 and e.r<0.8):
		on_color = 0
		$LesSprites/heros_couleur.modulate = global.colors[0]
	elif(c.g>0.6 and c.a>0.1 and e.r<0.8):
		on_color = 1
		$LesSprites/heros_couleur.modulate = global.colors[1]
	elif(c.b>0.6 and c.a>0.1 and e.r<0.8):
		on_color = 2
		$LesSprites/heros_couleur.modulate = global.colors[2]
	#else:
	#	on_color = -1
	#	$LesSprites/heros_couleur.modulate = Color(0.5,0.5,0.5)

func _on_kill(position, score_gained,color):
	if color != null and jauges[colormap[color]] < max_jauge:
		jauges[colormap[color]] += 1
	
func _on_jauge_empty_timeout():
	print("salut")
	for jauge in jauges.size():
		if jauges[jauge] > 0:
			jauges[jauge] -= 1
	jauge_empty_timer.start()


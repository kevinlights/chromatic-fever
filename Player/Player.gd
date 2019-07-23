"""
Licensed under GPL-3.0-or-later
Copyright (C) 2019 Louka Soret

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

extends KinematicBody2D

signal player_hit()
signal player_die()
signal screen_freeze(duration)
signal screen_shake(duration)

onready var projectiles : Node2D = get_node("/root/Game/Projectiles")

onready var projectile_ressource : Resource = load("res://Player/Projectile.tscn")
onready var peintures : Sprite = get_node("/root/Game/Paint/Sprite")
onready var effacements : Viewport = get_node("/root/Game/Paint/Viewport_effacements")
onready var enemies = get_node("/root/Game/Characters/Enemies")


onready var game = get_node("/root/Game")
onready var global = get_node("/root/Global")

# Movement parameters
export var acceleration : int = 1200
export var deceleration : int = 1200
export var top_speed : int = 400
export var on_hit_speed : int = 20000
export var jauge_empty_delay : float = 10
export var max_jauge : int = 10

# Attributes vars
export var max_health : int = 3
var firing_rate : float = 0
export var color_change_delay : float = 0.5
export var invincibility_duration : float = 1.5
export var double_fire_rate : float = 0.1

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
var double_fire : bool = false

# State vars
var invincible : bool = true

# Timers
var firing_rate_timer : float = 0
var invincibility_timer : float = 0
var color_change_timer : float = 0
var jauge_empty_timer : float = 0

var time_surprise = 0
var i_surprise = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	combo_map = {game.COMBO.NONE : 0.4,
				game.COMBO.TAINTED : 0.6,
				game.COMBO.PIGMENTED : 0.2,
				game.COMBO.COLOURFUL : 0.1,
				game.COMBO.CHROMATIC : 0.4}
	firing_rate =combo_map[game.COMBO.NONE]
	double_fire = true if game.combo == game.COMBO.TAINTED else false
	enemies.connect("enemy_died",self,"_on_kill")
	connect("screen_shake",$Camera2D,"_camera_shake")
	connect("screen_freeze",$Camera2D,"_camera_freeze")
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
		time_surprise = OS.get_ticks_msec()
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
	
	velocity = move_and_slide(velocity)
	
	# Orientation
	$Hand.look_at(get_global_mouse_position())
	
	# Shoot Inputs
	firing_rate_timer += delta
	if Input.is_action_pressed("ui_shoot") and firing_rate_timer >= firing_rate:
		shoot()
		firing_rate = double_fire_rate if double_fire and firing_rate != double_fire_rate else combo_map[game.combo]
		firing_rate_timer = 0
	
	double_fire = true if game.combo == game.COMBO.TAINTED else false
	
	# update color
	color_change_timer += delta
	if color_change_timer >= color_change_delay:
		color_update()
		color_change_timer = 0
		
	# invicibility timer
	if invincible:
		invincibility_timer += delta
		if invincibility_timer >= invincibility_duration:
			invincible = false
	
	# jauges  timer
	jauge_empty_timer += delta
	if jauge_empty_timer >= jauge_empty_delay:
		jauge_empty_timeout()
		jauge_empty_timer = 0

func shoot():
	var projectile : Projectile = projectile_ressource.instance()
	projectile.position = $Hand/ProjectilesSpawnPosition.get_global_position()
	projectile.direction = (get_global_mouse_position() - global_position).normalized()
	projectile.explosive = game.combo == game.COMBO.CHROMATIC
	if(projectile.explosive):
		# C'est NON
		#emit_signal("screen_shake",0.2)
		velocity -= projectile.direction * 200
	projectiles.add_child(projectile)
	projectile.make_connections()
	var soundToPlay = randi()%4+1
	match soundToPlay:
		1:
			$Sounds/shot1.play()
		2:
			$Sounds/shot2.play()
		3:
			$Sounds/shot3.play()
	$Hand.shoot()

func hit(collision_normal : Vector2):
	if not invincible and health > 0:
		#emit_signal("screen_freeze",0.8)
		emit_signal("screen_shake",0.8)
		health -= 1
		velocity = collision_normal*on_hit_speed
		invincible = true
		invincibility_timer = 0
		$Sounds/oof.play()
		emit_signal("player_hit")
		$AnimationPlayer.play("hurt")
		if health <= 0:
			set_physics_process(false)
			yield(get_tree().create_timer(0.8),"timeout")
			die()
	
func die():
	hide()
	emit_signal("player_die")
	get_tree().paused = true
	
func color_update():
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
	
func jauge_empty_timeout():
	for jauge in jauges.size():
		if jauges[jauge] > 0:
			jauges[jauge] -= 1
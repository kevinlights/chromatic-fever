extends KinematicBody2D

class_name EnemyCAC

signal enemy_hit(dmg)
signal enemy_died(position, score_gained, color)
signal screen_freeze(duration)
signal screen_shake(duration)

export var acceleration : int = 300
export var deceleration : int = 300
export var top_speed : int = 100
export var charge_top_speed : int = 500
export var on_hit_speed : int = 200
export var on_hit_deceleration : int = 5
export var max_health : int = 3
export var color : Color = Color(0,0,1)
export var score_when_killed = 100

onready var global = get_node("/root/Global")
onready var player : KinematicBody2D = get_node("/root/Game/Characters/Player")
onready var paint_canvas : Node2D = get_node("/root/Game/Paint")
onready var camera : Camera2D = get_node("/root/Game/Characters/Player/Camera2D")

#Movement
var speed : int = top_speed
var direction : Vector2
var velocity : Vector2 = Vector2()
var health : int = max_health

var charging : bool = false
var hit : bool = false
var can_erase : bool = true

#Timer
export var direction_change_delay : float = 1
export var erase_delay : float = 1
export var charge_delay : float = 3
export var charge_duration : float = 3
var direction_change_timer : float = direction_change_delay
var erase_timer : float = 0.0
var charge_timer : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	charge_timer = rand_range(0.0,charge_delay)
	$LesSprites/AnimationPlayer.play("marche")
	$LesSprites/tete.modulate = color

func make_connections():
	connect("screen_shake",camera,"_camera_shake")
	connect("screen_freeze",camera,"_camera_freeze")
	$HitBox.make_connections()

func _physics_process(delta):
	
	charge_timer += delta
	direction_change_timer += delta
	direction = movement_oracle()
	
	# Movements
	
	if hit:
		velocity = lerp(velocity,Vector2.ZERO,on_hit_deceleration*delta)
		if velocity.length() < 2 :
			velocity = Vector2.ZERO
			hit = false
	else:
		velocity += acceleration*direction.normalized()*delta
		
		var top_directional_speed : Vector2 = velocity.normalized()*speed
		velocity.x = clamp(velocity.x,-abs(top_directional_speed.x),abs(top_directional_speed.x))
		velocity.y = clamp(velocity.y,-abs(top_directional_speed.y),abs(top_directional_speed.y))
	
	erase_timer += delta
	if erase_timer >= erase_delay :
		paint_canvas.spawn_effacement(global_position)
		erase_timer = 0.0
	
	move_and_collide(velocity*delta)

func movement_oracle() -> Vector2:
	if charge_timer >= charge_delay :
		if charge_timer < charge_delay + charge_duration and charging:
			return global_position.direction_to(player.global_position).normalized()
			
		if not charging and $VisibilityNotifier2D.is_on_screen():
			if player != null :
				charging = true
				speed = charge_top_speed
				velocity = Vector2.ZERO
				return global_position.direction_to(player.global_position).normalized()
			else :
				return Vector2.ZERO
		if charge_timer >= charge_delay + charge_duration and charging:
			charge_timer = 0.0
			charging = false
			speed = top_speed
	if charge_timer < charge_delay or not charging :
		if direction_change_timer >= direction_change_delay:
			var angle : float = rand_range(-90,90)
			var new_direction : Vector2 = global_position.direction_to(camera.global_position).normalized().rotated(deg2rad(angle))
			direction_change_timer = 0.0
			return new_direction
		else:
			return direction
	return direction

func hit(collision_normal):
	if health > 0:
		if player.on_color != -1 and global.colors[player.on_color] == color:
			emit_signal("enemy_hit",health)
			health = 0
		else:
			health -= 1
			emit_signal("enemy_hit",1)
		
		if health <= 0:
			$AnimationPlayer.play("die")
			die()
		else:
			$AnimationPlayer.play("hurt")
		if not charging:
			velocity = collision_normal.normalized()*on_hit_speed
		hit = true
		#emit_signal("screen_freeze",0)
		#emit_signal("screen_shake",0.8)

func die():
	$Sounds/Death.play()
	yield($AnimationPlayer, "animation_finished")
	paint_canvas.spawn_peinture(global_position,color)
	emit_signal("enemy_died", get_global_transform_with_canvas().origin, score_when_killed,color)
	#get_parent().remove_child(self)
	self.queue_free()
extends KinematicBody2D

class_name Enemy

signal enemy_hit(dmg)
signal enemy_died(position, score_gained, color)
signal screen_freeze(duration)
signal screen_shake(duration)

export var acceleration : int = 300
export var deceleration : int = 300
export var top_speed : int = 50
export var on_hit_speed : int = 200
export var on_hit_deceleration : int = 5
export var max_health : int = 3
export var color : Color = Color(0,0,1)
export var score_when_killed = 100

onready var global = get_node("/root/Global")
onready var player : KinematicBody2D = get_node("/root/Game/Characters/Player")
onready var paint_canvas : Node2D = get_node("/root/Game/Paint")
onready var camera : Camera2D = get_node("/root/Game/Player/Camera2D")

#Movement
var direction : Vector2
var velocity : Vector2 = Vector2()
var hit : bool = false
var health : int = max_health

#Timer
export var erase_delay : float = 1
var erase_timer : Timer = Timer.new()
var can_erase : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$LesSprites/AnimationPlayer.play("marche")
	erase_timer.set_one_shot(true)
	erase_timer.set_wait_time(erase_delay)
	add_child(erase_timer)
	$LesSprites/tete.modulate = color

func make_connections():
	connect("screen_shake",camera,"_camera_shake")
	connect("screen_freeze",camera,"_camera_freeze")
	erase_timer.connect("timeout",self,"_on_erase_delay_timeout")
	$HitBox.make_connections()

func _physics_process(delta):
	direction = Vector2()
	
	direction = movement_oracle()
	
	# Movements
	
	if hit:
		velocity = lerp(velocity,Vector2.ZERO,on_hit_deceleration*delta)
		if velocity.length() < 2 :
			velocity = Vector2.ZERO
			hit = false
	else:
		velocity += acceleration*direction.normalized()*delta
		
		var top_directional_speed : Vector2 = velocity.normalized()*top_speed
		velocity.x = clamp(velocity.x,-abs(top_directional_speed.x),abs(top_directional_speed.x))
		velocity.y = clamp(velocity.y,-abs(top_directional_speed.y),abs(top_directional_speed.y))
	
	if can_erase :
		paint_canvas.spawn_effacement(global_position)
		can_erase = false
		erase_timer.start()
	
	move_and_collide(velocity*delta)

func movement_oracle() -> Vector2:
	if player != null :
		return (player.global_position - global_position).normalized()
	else :
		return Vector2.ZERO

func _on_erase_delay_timeout():
	can_erase = true

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
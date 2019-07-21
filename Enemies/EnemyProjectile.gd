extends Area2D

class_name EnemyProjectile
onready var player_hitbox = get_node("/root/Game/Characters/Player/HitBox")
onready var terrain = get_node("/root/Game/Terrain/Feuille")

export var speed : int = 250

var direction : Vector2
var veloctity : Vector2

func _physics_process(delta):
	veloctity = direction*speed
	global_position += veloctity*delta

func make_connections():
	connect("area_entered",player_hitbox,"_on_enemy_hit")
	connect("area_entered",self,"_on_projectile_hit")

func _on_projectile_hit(area : Area2D):
	if self != null and get_parent() != null:
		self.queue_free()
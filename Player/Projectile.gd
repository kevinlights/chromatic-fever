extends Area2D

class_name Projectile

onready var enemies : Node2D = get_node("/root/Game/Enemies")
onready var terrain = get_node("/root/Game/Terrain/Feuille")

export var speed : int = 300

var direction : Vector2
var veloctity : Vector2

func _physics_process(delta):
	veloctity = direction*speed
	global_position += veloctity*delta
	
	if global_position.x<0 or global_position.y<0:
		get_parent().remove_child(self)
	if global_position.x>terrain.texture.get_size().x*terrain.scale.x or global_position.y>terrain.texture.get_size().y*terrain.scale.y:
		get_parent().remove_child(self)

func _ready():
	for enemy in enemies.get_children():
		connect("area_entered",enemy.get_node("HitBox"),"_on_projectile_hit")
	connect("area_entered",self,"_on_projectile_hit")

func _on_projectile_hit(area : Area2D):
	get_parent().remove_child(self)
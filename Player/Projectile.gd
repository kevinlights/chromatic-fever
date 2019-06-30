extends Area2D

class_name Projectile

onready var enemies : Node2D = get_node("/root/Game/Enemies")
onready var terrain = get_node("/root/Game/Terrain/Feuille")

export var speed : int = 1500

var direction : Vector2
var veloctity : Vector2

func _physics_process(delta):
	veloctity = direction*speed
	global_position += veloctity*delta

func make_connections():
	for body in get_tree().get_nodes_in_group("projectile_collisions"):
		connect("area_entered",body.get_node("HitBox"),"_on_projectile_hit")
	connect("area_entered",self,"_on_projectile_hit")
	$AnimationPlayer.play("gros")

func _on_projectile_hit(area : Area2D):
	if self != null:
		get_parent().remove_child(self)
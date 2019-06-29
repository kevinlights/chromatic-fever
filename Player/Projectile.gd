extends Area2D

class_name Projectile

onready var enemies : Node2D = get_node("/root/Game/Enemies")

export var speed : int = 300

var direction : Vector2
var veloctity : Vector2

func _physics_process(delta):
	veloctity = direction*speed*delta
	global_position += veloctity*delta

func _ready():
	for enemy in enemies.get_children():
		connect("area_entered",enemy.get_node("HitBox"),"_on_projectile_hit")
	connect("area_entered",self,"_on_projectile_hit")

func _on_projectile_hit(area : Area2D):
	get_parent().remove_child(self)
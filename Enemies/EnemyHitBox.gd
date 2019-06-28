extends Area2D

onready var player = get_node("/root/Game/Player/HitBox")

func _ready():
	connect("area_entered",player,"_on_enemy_hit")
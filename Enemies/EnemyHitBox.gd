extends Area2D

onready var player = get_node("/root/Game/Player/HitBox")

func _ready():
	connect("area_entered",player,"_on_enemy_hit")
	
func _on_projectile_hit(area : Area2D):
	if area == self:
		get_parent().hit()
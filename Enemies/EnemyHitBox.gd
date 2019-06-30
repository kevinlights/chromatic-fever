extends Area2D

onready var player = get_node("/root/Game/Player/HitBox")

func make_connections():
	connect("area_entered",player,"_on_enemy_hit")
	
func _on_projectile_hit(area : Area2D):
	if self != null and get_parent() != null:
		if area == self:
			var collision_normal : Vector2 = Vector2()
			for overlapping_area in get_overlapping_areas():
				 collision_normal += (global_position - overlapping_area.global_position).normalized()
			get_parent().hit(collision_normal.normalized())
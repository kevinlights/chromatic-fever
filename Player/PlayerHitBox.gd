extends Area2D

func _on_enemy_hit(area : Area2D):
	if self != null and get_parent() != null:
		if self == area:
			var collision_normal : Vector2 = Vector2()
			for overlapping_area in get_overlapping_areas():
				collision_normal += (global_position - overlapping_area.global_position).normalized()
			if collision_normal != Vector2.ZERO:
				get_parent().hit(collision_normal)
extends Area2D

func _on_enemy_hit(area : Area2D):
	if self == area:
		get_parent().hit()
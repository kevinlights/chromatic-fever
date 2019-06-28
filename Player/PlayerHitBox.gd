extends Area2D

func _on_enemy_hit(area : Area2D):
	get_parent().hit()
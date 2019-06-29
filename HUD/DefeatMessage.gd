extends Label

onready var player : KinematicBody2D = get_node("/root/Game/Player")

func _ready():
	hide()
	player.connect("player_die", self, "_on_player_die")
	
func _on_player_die():
	show()
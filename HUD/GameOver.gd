extends VBoxContainer

onready var player : KinematicBody2D = get_node("/root/Game/Player")
onready var hud = get_parent().get_parent().get_parent()

var is_game_over = false

func _ready():
	hide()
	player.connect("player_die", self, "_on_player_die")
	
func _process(delta):
		if is_game_over && Input.is_action_pressed("ui_shoot"):
			get_tree().reload_current_scene()
			
func _on_player_die():
	is_game_over = true
	$ScoreFinal.set_text("Score : " + str(hud.score))
	show()
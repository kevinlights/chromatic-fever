extends CanvasLayer

var score = 0
onready var enemy : KinematicBody2D = get_node("/root/Game/Enemies")
onready var game : KinematicBody2D = get_node("/root/Game")
onready var rainbow_message_scene = preload("res://HUD/RainbowMessage.tscn")

func _ready():
	enemy.connect("enemy_died", self, "_on_enemy_died")
	game.connect("tainted", self, "_on_tainted")
	game.connect("pigmented", self, "_on_pigmented")
	game.connect("colourful", self, "_on_colourful")
	game.connect("chromatic", self, "_on_chromatic")
	
func _on_enemy_died(position, score_gained):
	#Update score
	score += score_gained
	
	#Update scorelabel
	$Score.set_text(str(score))
	
	#Show a message where the enemy died
	#var message = rainbow_message_scene.instance()
	#add_child(message)
	#message.init(0.5, position)
	#message.write_message("+" + str(score_gained))
	
func create_combo_message(combo_name):
	var message = rainbow_message_scene.instance()
	message.set_sound_object(combo_name)
	message.write_message(combo_name)
	$CenterContainer.add_child(message)
	
func _on_tainted():
	create_combo_message("TAINTED")
	
func _on_pigmented():
	create_combo_message("PIGMENTED")

func _on_colourful():
	create_combo_message("COLOURFUL")
	
func _on_chromatic():
	create_combo_message("CHROMATIC")
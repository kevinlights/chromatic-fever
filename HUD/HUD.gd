extends CanvasLayer

onready var enemy : KinematicBody2D = get_node("/root/Game/Enemies")
onready var game : KinematicBody2D = get_node("/root/Game")
onready var rainbow_message_scene = preload("res://HUD/RainbowMessage.tscn")

var score = 0

var message = null

func _ready():
	game.connect("tainted", self, "_on_tainted")
	game.connect("pigmented", self, "_on_pigmented")
	game.connect("colourful", self, "_on_colourful")
	game.connect("chromatic", self, "_on_chromatic")
	game.connect("combo_broken", self, "_on_combo_broken")
	game.connect("multiplier_set", self, "_on_multiplier_set")

func create_combo_message(combo_name):
	if message != null:
		remove_child(message)
	message = rainbow_message_scene.instance()
	message.set_sound_object(combo_name)
	message.write_message(combo_name)
	add_child(message)
	
func _on_tainted():
	create_combo_message("TAINTED")
	
func _on_pigmented():
	create_combo_message("PIGMENTED")

func _on_colourful():
	create_combo_message("COLOURFUL")
	
func _on_chromatic():
	create_combo_message("CHROMATIC")
	
func _on_combo_broken():
	if message != null:
		remove_child(message)
		
func _on_multiplier_set(multiplier: int):
	if multiplier == 1:
		$ScoreContainer/Node2D/ScoreMultiplier.set_text("")
	else :
		$ScoreContainer/Node2D/ScoreMultiplier.set_text("x"+str(multiplier)+"!")
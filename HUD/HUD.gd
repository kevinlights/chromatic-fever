extends CanvasLayer

onready var enemy : KinematicBody2D = get_node("/root/Game/Enemies")
onready var game : KinematicBody2D = get_node("/root/Game")
onready var rainbow_message_scene = preload("res://HUD/RainbowMessage.tscn")
onready var tween_out = $Sounds/Tween

var score = 0

var message = null
var current_music = null

export var transition_duration = 2.00
export var transition_type = 1

func _ready():
	game.connect("tainted", self, "_on_tainted")
	game.connect("pigmented", self, "_on_pigmented")
	game.connect("colourful", self, "_on_colourful")
	game.connect("chromatic", self, "_on_chromatic")
	game.connect("combo_broken", self, "_on_combo_broken")
	game.connect("multiplier_set", self, "_on_multiplier_set")
	current_music = $Sounds/colorless_world
	current_music.play()

func create_combo_message(combo_name):
	if message != null:
		remove_child(message)
	message = rainbow_message_scene.instance()
	message.set_sound_object(combo_name)
	message.write_message(combo_name)
	add_child(message)
	
func play_music(sound_object):
	tween_out.interpolate_property(current_music, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	current_music = sound_object
	sound_object.play()

func _on_Tween_tween_completed(object, key):
	object.stop()
	
func _on_tainted():
	play_music($Sounds/tainted_world)
	create_combo_message("TAINTED")
	
func _on_pigmented():
	play_music($Sounds/pigmented_world)
	create_combo_message("PIGMENTED")

func _on_colourful():
	play_music($Sounds/colourful_world)
	create_combo_message("COLOURFUL")
	
func _on_chromatic():
	play_music($Sounds/chromatic_world)
	create_combo_message("CHROMATIC")

func _on_combo_broken():
	if message != null:
		remove_child(message)
	play_music($Sounds/colorless_world)
		
func _on_multiplier_set(multiplier: int):
	if multiplier == 1:
		$ScoreContainer/Node2D/ScoreMultiplier.set_text("")
	else :
		$ScoreContainer/Node2D/ScoreMultiplier.set_text("x"+str(multiplier)+"!")

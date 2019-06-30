extends CanvasLayer

onready var enemy : KinematicBody2D = get_node("/root/Game/Enemies")
onready var game : KinematicBody2D = get_node("/root/Game")
onready var rainbow_message_scene = preload("res://HUD/RainbowMessage.tscn")

var score = 0

var message = null
var musics = null

func _ready():
	game.connect("tainted", self, "_on_tainted")
	game.connect("pigmented", self, "_on_pigmented")
	game.connect("colourful", self, "_on_colourful")
	game.connect("chromatic", self, "_on_chromatic")
	game.connect("combo_broken", self, "_on_combo_broken")
	game.connect("multiplier_set", self, "_on_multiplier_set")
	musics = [$Sounds/tainted_world, $Sounds/pigmented_world, $Sounds/colourful_world, $Sounds/chromatic_world]

func create_combo_message(combo_name):
	if message != null:
		remove_child(message)
	message = rainbow_message_scene.instance()
	message.set_sound_object(combo_name)
	message.write_message(combo_name)
	add_child(message)
	
func stop_all_musics():
	for i in range(musics.size()):
		musics[i].stop()
		
func _on_tainted():
	stop_all_musics()
	$Sounds/tainted_world.play()
	create_combo_message("TAINTED")
	
func _on_pigmented():
	stop_all_musics()
	$Sounds/pigmented_world.play()
	create_combo_message("PIGMENTED")

func _on_colourful():
	stop_all_musics()
	$Sounds/colourful_world.play()
	create_combo_message("COLOURFUL")
	
func _on_chromatic():
	stop_all_musics()
	$Sounds/chromatic_world.play()
	create_combo_message("CHROMATIC")

func _on_combo_broken():
	if message != null:
		remove_child(message)
	stop_all_musics()
		
func _on_multiplier_set(multiplier: int):
	if multiplier == 1:
		$ScoreContainer/HBox/ScoreMultiplier.set_text("")
	else :          
		$ScoreContainer/HBox/ScoreMultiplier.set_text("x"+str(multiplier)+"!")
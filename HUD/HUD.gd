"""
Licensed under GPL-3.0-or-later
Copyright (C) 2019 Louka Soret

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

extends CanvasLayer

signal countdown_finished()

onready var enemy : KinematicBody2D = get_node("/root/Game/Characters/Enemies")
onready var game : KinematicBody2D = get_node("/root/Game")
onready var rainbow_message_scene = preload("res://HUD/RainbowMessage.tscn")
onready var tween_out = $Sounds/Tween

export var transition_duration = 2.00
export var transition_type = 1

var score = 0

var message = null
var current_music = null

#var ca_combo_map : Dictionary = {"TAINTED":0.002,"PIGMENTED":0.003,"COLOURFUL":0.004,"CHROMATIC":0.005}


func _ready():
	game.connect("tainted", self, "_on_tainted")
	game.connect("pigmented", self, "_on_pigmented")
	game.connect("colourful", self, "_on_colourful")
	game.connect("chromatic", self, "_on_chromatic")
	game.connect("combo_broken", self, "_on_combo_broken")
	game.connect("multiplier_set", self, "_on_multiplier_set")
	#connect("countdown_finished",game,"_on_countdown_finished")
	current_music = $Sounds/colorless_world
	current_music.play()

func create_combo_message(combo_name):
	if message != null:
		message.queue_free()
	var m = rainbow_message_scene.instance()
	message = m.get_node("RainbowMessage")
	message.set_sound_object(combo_name)
	message.write_message(combo_name)
	add_child_below_node($LesCadres,m)
	
func play_music(sound_object):
	#tween_out.interpolate_property(current_music, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	#tween_out.start()
	current_music.stop()
	current_music = sound_object
	sound_object.play()

func play_countdown():
	$Sounds/countdown.play()
	$CountDown/Label.set_text("3")
	$CountDown.show()
	$CountDown/AnimationPlayer.play("countdown_label")
	yield($CountDown/AnimationPlayer, "animation_finished")
	$CountDown/Label.set_text("2")
	$CountDown/AnimationPlayer.play("countdown_label")
	yield($CountDown/AnimationPlayer, "animation_finished")
	$CountDown/Label.set_text("1")
	$CountDown/AnimationPlayer.play("countdown_label")
	yield($CountDown/AnimationPlayer, "animation_finished")
	$CountDown.hide()
	emit_signal("countdown_finished")

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
		#remove_child(message)
		message.queue_free()
	$ChromaticAberation.material.set_shader_param("scale",0.0)
	play_music($Sounds/colorless_world)
		
func _on_multiplier_set(multiplier: int):
	if multiplier == 1:
		$ScoreContainer/Node2D/ScoreMultiplier.set_text("")
	else :
		$ScoreContainer/Node2D/ScoreMultiplier.set_text("x"+str(multiplier)+"!")

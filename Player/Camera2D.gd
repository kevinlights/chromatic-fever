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

extends Camera2D

onready var game : KinematicBody2D = get_node("/root/Game")

#Shake configuration
export var shake_amplitude : Vector2 = Vector2(4,4)
export(float, EASE) var SHAKE_DAMP_EASING = 1.0

# Shake vars
var shake : bool = false
var shake_timer : Timer = Timer.new()
var shake_duration : float = 0.8 # sec

func _ready():
	game.connect("tainted", self, "_on_tainted")
	game.connect("pigmented", self, "_on_pigmented")
	game.connect("colourful", self, "_on_colourful")
	game.connect("chromatic", self, "_on_chromatic")
	game.connect("combo_broken", self, "_on_combo_broken")
	
	
	randomize()
	shake_timer.set_one_shot(true)
	shake_timer.set_wait_time(shake_duration)
	shake_timer.connect("timeout",self,"_on_shake_timeout")
	add_child(shake_timer)

func _physics_process(delta):
	if shake:
		var damping = ease(shake_timer.time_left/shake_timer.wait_time,SHAKE_DAMP_EASING)
		offset = Vector2(rand_range(shake_amplitude.x,-shake_amplitude.x),rand_range(shake_amplitude.y,-shake_amplitude.y))
		offset *= damping

func _on_shake_timeout():
	shake = false
	
func _camera_shake(duration : float):
	shake_duration = duration
	shake_timer.wait_time = shake_duration
	shake = true
	shake_timer.start()
	
func _camera_freeze(duration : float):
	OS.delay_msec(duration*100)
	
func _on_combo_broken():
	shake_amplitude = Vector2(4,4)
	
func _on_tainted():
	shake_amplitude = Vector2(6,6)
		
func _on_pigmented():
	shake_amplitude = Vector2(8,8)

func _on_colourful():
	shake_amplitude = Vector2(10,10)
	
func _on_chromatic():
	shake_amplitude = Vector2(12,12)
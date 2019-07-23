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

extends Label

onready var enemy : KinematicBody2D = get_node("/root/Game/Characters/Enemies")
onready var game : KinematicBody2D = get_node("/root/Game")
onready var scone_gain_message_resource = load("res://HUD/ScoreGainMessage.tscn")

export var font_min_size : int = 40
export var font_scale_speed : int = 60
export var font_scale_delay : int = 0.5

var score : int = 0
var multiplier : int = 1

var font_scale_timer : float = 0.0
var running : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	enemy.connect("enemy_died", self, "_on_enemy_died")
	game.connect("multiplier_set", self, "_on_multiplier_set")
	get_font("font").size = font_min_size
	set_physics_process(false)

func _process(delta):
	if running:
		font_scale_timer += delta
		if font_scale_timer >= font_scale_delay:
			running = false
			set_physics_process(true)

func _physics_process(delta):
	if get_font("font").size > font_min_size:
		get_font("font").size -= font_scale_speed*delta
	else :
		get_font("font").size = font_min_size
		set_physics_process(false)

func _on_enemy_died(position, score_gained,color):
	
	#Show a message where the enemy died
	var message = scone_gain_message_resource.instance()
	message.init("+"+str(score_gained*multiplier),position, get_parent().get_parent().get_rect().position,color)
	get_parent().get_parent().get_parent().add_child(message)
	yield(message,"goal_reached")
	
	#Update score
	score += score_gained*multiplier
	
	#Update scorelabel
	set_text(str(score))
	get_font("font").size = score_gained/1.5
	set_physics_process(false)
	running = true
	font_scale_timer = 0.0
	
func _on_multiplier_set(multiplier):
	self.multiplier = multiplier
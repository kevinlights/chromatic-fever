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

extends Node2D

onready var global = get_node("/root/Global")
onready var player = get_node("/root/Game/Characters/Player/LesSprites/heros_couleur")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time_start = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cadre.modulate = global.colors[1]
	$Cadre2.modulate = global.colors[1]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var alpha = ((sin(OS.get_ticks_msec()*0.005)+1)*0.5)*0.5+0.25
	if(player.modulate.r != 0.5 and player.modulate.g != 0.5 and player.modulate.b != 0.5):
		$Cadre.modulate = player.modulate
		$Cadre2.modulate = player.modulate
	$Cadre.modulate.a = alpha
	$Cadre2.modulate.a = alpha
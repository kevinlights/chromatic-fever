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

extends VBoxContainer

onready var player : KinematicBody2D = get_node("/root/Game/Characters/Player")
onready var hud = get_parent().get_parent().get_parent()

var is_game_over = false

func _ready():
	hide()
	player.connect("player_die", self, "_on_player_die")
	
func _process(delta):
		if is_game_over && Input.is_action_pressed("ui_restart"):
			get_tree().reload_current_scene()
			
func _on_player_die():
	is_game_over = true
	$ScoreFinal.set_text("Score : " + str(hud.score))
	show()
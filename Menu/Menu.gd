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

extends Control

func _ready():
	$VBoxContainer/NewGameButton.connect("pressed",self,"_on_new_game_button_entered")
	$VBoxContainer/QuitButton.connect("pressed",self,"_on_quit_button_entered")
	$VBoxContainer/NewGameButton.connect("mouse_entered",self,"_on_newgame_button_hovered")
	$VBoxContainer/QuitButton.connect("mouse_entered",self,"_on_quit_button_hovered")
	$VBoxContainer/NewGameButton.connect("mouse_exited",self,"_on_button_unhovered")
	$VBoxContainer/QuitButton.connect("mouse_exited",self,"_on_button_unhovered")

func _on_new_game_button_entered():
	get_tree().change_scene("res://Game.tscn")

func _on_tutorial_button_entered():
	$TutorialPanel.show()

func _on_quit_button_entered():
	get_tree().quit()
	
func _on_newgame_button_hovered():
	$Hand.show()
	$Hand.rect_position = Vector2(170,290)
	
func _on_quit_button_hovered():
	$Hand.show()
	$Hand.rect_position = Vector2(170,420)
	
func _on_button_unhovered():
	$Hand.hide()
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and $TutorialPanel.visible:
		$TutorialPanel.hide()
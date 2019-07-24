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

signal goal_reached()

export var speed : int = 750
#export var font_min_size : int = 10
#export var font_max_size : int = 30
#export var font_scale_speed : int = 80

var target : Vector2
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(msg : String, start : Vector2, goal : Vector2, color : Color):
	set_text(msg)
	set_position(start)
	direction = (goal - start).normalized()
	add_color_override("font_color",color)
	#get_font("font").size = font_min_size
	target = goal

func _process(delta):
	var new_direction : Vector2
	
	set_position(get_position() + speed*delta*direction)
	"""if get_font("font").size < font_max_size:
		get_font("font").size += font_scale_speed*delta
	else :
		get_font("font").size = font_max_size
	"""
	
	new_direction = (target - get_position()).normalized()
	
	if direction.x > 0 and new_direction.x <= 0 or direction.x < 0 and new_direction.x >= 0 or direction.y > 0 and new_direction.y <= 0 or direction.y < 0 and new_direction.y >= 0 :
		get_parent().remove_child(self)
		emit_signal("goal_reached")
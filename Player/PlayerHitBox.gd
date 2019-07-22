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

extends Area2D

func _on_enemy_hit(area : Area2D):
	if self != null and get_parent() != null:
		if self == area:
			var collision_normal : Vector2 = Vector2()
			for overlapping_area in get_overlapping_areas():
				collision_normal += (global_position - overlapping_area.global_position).normalized()
			#if collision_normal != Vector2.ZERO:
			get_parent().hit(collision_normal)
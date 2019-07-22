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

extends HBoxContainer

onready var enemy = get_parent()
var heart_array : Array = []

func _ready():
	# Creating the heart pictures
	heart_array.append($Heart)
	for i in range(enemy.max_health-1):
		var newHeart = $Heart.duplicate()
		heart_array.append(newHeart)
		add_child(newHeart)
	
	# Signal connection
	enemy.connect("enemy_hit", self, "_on_enemy_hit")

func find_last_full_heart():
	var i = heart_array.size()-1
	while i < 0 || !heart_array[i].is_full :
		i -= 1
	
	if i >= 0:
		return heart_array[i]

func _on_enemy_hit(dmg):
	var heart
	for i in dmg:
		heart = find_last_full_heart()
		if heart:
			heart.set_empty()
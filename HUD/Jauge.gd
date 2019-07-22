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

extends TextureProgress

onready var player = get_node("/root/Game/Characters/Player")
onready var global = get_node("/root/Global")


export var jauge_number : int 

func _ready():
	modulate = global.colors[jauge_number]
	max_value = player.max_jauge

func _process(delta):
	set_value(player.jauges[jauge_number])
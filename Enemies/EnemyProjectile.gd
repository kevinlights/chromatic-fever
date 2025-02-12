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

class_name EnemyProjectile
onready var player_hitbox = get_node("/root/Game/Characters/Player/HitBox")
#onready var terrain = get_node("/root/Game/Terrain/Feuille")

export var speed : int = 250

var direction : Vector2
var veloctity : Vector2

var to_destroy : bool = false
var destroy_timer : float = 0.0

func _physics_process(delta):
	if not to_destroy :
		veloctity = direction*speed
		global_position += veloctity*delta
	else :
		destroy_timer += delta
		if destroy_timer >= 0.5:
			self.queue_free()

func make_connections():
	connect("area_entered",player_hitbox,"_on_enemy_hit")
	connect("area_entered",self,"_on_projectile_hit")

func _on_projectile_hit(area : Area2D):
	if self != null and get_parent() != null and not to_destroy:
		hide()
		veloctity = Vector2.ZERO
		to_destroy = true
		self.queue_free()
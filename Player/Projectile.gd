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

class_name Projectile

#onready var explosion_resource : Resource = load("res://Player/Explosion.tscn")
onready var explosion_resource : Resource = load("res://Player/Explosion_web.tscn")
onready var enemies : Node2D = get_node("/root/Game/Characters/Enemies")
onready var terrain = get_node("/root/Game/Terrain/Feuille")
onready var player : Sprite = get_node("/root/Game/Characters/Player/LesSprites/heros_couleur")
onready var game = get_node("/root/Game")

export var speed1 : int = 1500
export var speed2 : int = 500
export var explosive_extents : Vector2 = Vector2(6,6)

var explosive : bool = false

var direction : Vector2
var veloctity : Vector2
var speed = 500
var to_destroy : bool = false

var destroy_timer : float = 0.0

var explosion

func _ready():
	$bullet1.modulate = player.modulate
	speed = speed1
	if(game.combo == game.COMBO.CHROMATIC):
		$bullet1.visible = false
		$bullet2.visible = true
		$bullet2.self_modulate = player.modulate
		speed = speed2
	explosion = explosion_resource.instance()

func _physics_process(delta):
	if not to_destroy :
		veloctity = direction*speed
		global_position += veloctity*delta
	else :
		destroy_timer += delta
		if destroy_timer >= 0.1:
			for area in get_overlapping_areas():
				area._on_projectile_hit_e(area)
			self.queue_free()

func make_connections():
	for hb in get_tree().get_nodes_in_group("projectile_collisions"):
			connect("area_entered",hb,"_on_projectile_hit_e")
	connect("area_entered",self,"_on_projectile_hit")
	$AnimationPlayer.play("gros")

func explode():
	speed=0
	print(get_signal_connection_list("area_entered"))
	for hb in get_tree().get_nodes_in_group("projectile_collisions"):
		disconnect("area_entered",hb,"_on_projectile_hit_e")
	$CollisionShape2D.scale = explosive_extents
	explosive = false
	explosion.position = position
	explosion.set_color($bullet1.modulate)
	get_parent().add_child(explosion)
	explosion.play()

func _on_projectile_hit(area : Area2D):
	if self != null and get_parent() != null and not to_destroy:
		if explosive:
			explode()
			to_destroy = true
		else :
			self.queue_free()
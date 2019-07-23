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

signal enemy_died(position, score_gained,color)

enum ENEMY_TYPES{
	CAC,
	RANGED
}

onready var camera : Camera2D = get_node("/root/Game/Characters/Player/Camera2D") 
onready var terrain : Node2D = get_node("/root/Game/Terrain/Feuille")
onready var player : KinematicBody2D = get_node("/root/Game/Characters/Player")
onready var global = get_node("/root/Global")
onready var enemyCAC_resource : Resource = load("res://Enemies/EnemyCAC.tscn")
onready var enemyRanged_resource : Resource = load("res://Enemies/EnemyRanged.tscn")

export var player_safe_range : int = 200
export var max_concurent_enemies : int = 5
export var min_concurent_enemies : int = 1
export var max_spawn_enemies: int = 20
export var mod_threshold : int = 10
export var mod_step : int = 5
export var wave_step : int = 1
export var type_repartition : float = 0.5

export var scale_step : float = 0.1
export var health_step : int = 1
export var max_scale_mod : float = 0.3
export var  max_health_mod : int = 3

var scale_mod : float = 0.0
var health_mod : int = 0

func _ready():
	randomize()
	var type
	var r : float
	for i in global.colors.size():
		for j in max_concurent_enemies/global.colors.size():
			r = randf()
			type = ENEMY_TYPES.CAC if r <= type_repartition else ENEMY_TYPES.RANGED
			spawn(global.colors[i],type)
	max_concurent_enemies += wave_step

func _process(delta):
	randomize()
	var child_count : int = get_child_count()
	var type
	var r : float
	if get_child_count() <= min_concurent_enemies:
		for i in global.colors.size():
			for j in (max_concurent_enemies-min_concurent_enemies)/global.colors.size():
				r = randf()
				type = ENEMY_TYPES.CAC if r <= type_repartition else ENEMY_TYPES.RANGED
				spawn(global.colors[i],type,scale_mod,health_mod)
		if max_concurent_enemies < max_spawn_enemies:
			max_concurent_enemies += wave_step
		if max_concurent_enemies >= mod_threshold:
			mod_threshold += mod_step
			scale_mod = max_scale_mod if scale_mod >= max_scale_mod else scale_mod + scale_step
			health_mod = max_health_mod if health_mod >= max_health_mod else health_mod + health_step

func spawn(color : Color, type, scale_mod : float = 0, health_mod : int = 0):
	var pos : Vector2 = Vector2()
	
	var new_enemy
	match type:
		ENEMY_TYPES.CAC:
			new_enemy = enemyCAC_resource.instance()
		ENEMY_TYPES.RANGED:
			new_enemy = enemyRanged_resource.instance()
	pos.x = rand_range(0,terrain.texture.get_size().x*terrain.scale.x)
	pos.y = rand_range(0,terrain.texture.get_size().y*terrain.scale.y)
	
	while pos.distance_to(player.global_position) < player_safe_range:
		pos.x = rand_range(0,terrain.texture.get_size().x*terrain.scale.x)
		pos.y = rand_range(0,terrain.texture.get_size().y*terrain.scale.y)
	
	new_enemy.color = color
	new_enemy.scale += Vector2(scale_mod,scale_mod)
	new_enemy.max_health += health_mod
	new_enemy.health = new_enemy.max_health
	new_enemy.global_position = pos
	add_child(new_enemy)
	
	new_enemy.make_connections()
	new_enemy.connect("enemy_died", self, "_on_enemy_died")

func _on_enemy_died(position, score_gained,color):
	emit_signal("enemy_died", position, score_gained,color)


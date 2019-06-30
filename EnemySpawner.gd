extends Node2D

signal enemy_died(position, score_gained,color)

onready var camera : Camera2D = get_node("/root/Game/Player/Camera2D") 
onready var terrain : Node2D = get_node("/root/Game/Terrain/Feuille")
onready var player : KinematicBody2D = get_node("/root/Game/Player")
onready var global = get_node("/root/Global")
onready var enemy_resource : Resource = load("res://Enemies/Enemy.tscn")

export var player_safe_range : int = 50
export var max_concurent_enemies : int = 20
export var min_concurent_enemies : int = 4
export var wave_step : int = 5



func _ready():
	randomize()
	
	for i in global.colors.size():
		for j in max_concurent_enemies/global.colors.size():
			spawn(global.colors[i])

func _process(delta):
	var child_count : int = get_child_count()
	if get_child_count() <= min_concurent_enemies:
		for i in global.colors.size():
			for j in (max_concurent_enemies-min_concurent_enemies)/global.colors.size():
				spawn(global.colors[i])
		max_concurent_enemies += wave_step
		min_concurent_enemies += wave_step

func spawn(color : Color):
	var pos : Vector2 = Vector2()
	var new_enemy = enemy_resource.instance()
	pos.x = rand_range(0,terrain.texture.get_size().x*terrain.scale.x)
	pos.y = rand_range(0,terrain.texture.get_size().y*terrain.scale.y)
	
	while pos.distance_to(player.global_position) < player_safe_range:
		pos.x = rand_range(0,terrain.texture.get_size().x*terrain.scale.x)
		pos.y = rand_range(0,terrain.texture.get_size().y*terrain.scale.y)
	
	new_enemy.color = color
	
	new_enemy.global_position = pos
	add_child(new_enemy)
	
	new_enemy.make_connections()
	new_enemy.connect("enemy_died", self, "_on_enemy_died")

func _on_enemy_died(position, score_gained,color):
	emit_signal("enemy_died", position, score_gained,color)


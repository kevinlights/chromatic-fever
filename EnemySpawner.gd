extends Node2D

onready var camera : Camera2D = get_node("/root/Game/Player/Camera2D") 
onready var terrain : Node2D = get_node("/root/Game/Terrain/Feuille")
onready var player : KinematicBody2D = get_node("/root/Game/Player")

onready var enemy_resource : Resource = load("res://Enemies/Enemy.tscn")

export var player_safe_range : int = 50

func _ready():
	randomize()
	
	for i in 1:
		spawn()

func spawn():
	var pos : Vector2 = Vector2()
	var new_enemy = enemy_resource.instance()
	pos.x = rand_range(0,terrain.texture.get_size().x*terrain.scale.x)
	pos.y = rand_range(0,terrain.texture.get_size().y*terrain.scale.y)
	
	while pos.distance_to(player.global_position) < player_safe_range:
		pos.x = rand_range(0,terrain.texture.get_size().x*terrain.scale.x)
		pos.y = rand_range(0,terrain.texture.get_size().y*terrain.scale.y)
	
	new_enemy.global_position = pos
	add_child(new_enemy)
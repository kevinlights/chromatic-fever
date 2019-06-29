extends Node2D

onready var camera : Camera2D = get_node("/root/Game/Player/Camera2D") 
onready var terrain : Node2D = get_node("/root/Game/Terrain/feuille")
onready var player : KinematicBody2D = get_node("/root/Game/Player")

export var player_safe_range : int = 50

func _ready():
	randomize()

func spawn():
	var pos : Vector2 = Vector2()
	pos.x = rand_range(0,terrain.texture.size.x)
	pos.y = rand_range(0,terrain.texture.size.y)
	
	while pos.distance_to(player.global_position) < player_safe_range:
		pos.x = rand_range(0,terrain.texture.size.x)
		pos.y = rand_range(0,terrain.texture.size.y)
extends Particles2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var enemy : KinematicBody2D = get_node("..")

# Called when the node enters the scene tree for the first time.
func _ready():
	process_material.color = enemy.color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

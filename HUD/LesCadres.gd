extends Node2D

onready var global = get_node("/root/Global")
onready var player = get_node("/root/Game/Characters/Player/LesSprites/heros_couleur")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time_start = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cadre.modulate = global.colors[1]
	$Cadre2.modulate = global.colors[1]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var alpha = ((sin(OS.get_ticks_msec()*0.005)+1)*0.5)*0.5+0.25
	if(player.modulate.r != 0.5 and player.modulate.g != 0.5 and player.modulate.b != 0.5):
		$Cadre.modulate = player.modulate
		$Cadre2.modulate = player.modulate
	$Cadre.modulate.a = alpha
	$Cadre2.modulate.a = alpha
extends Label

onready var enemy : KinematicBody2D = get_node("/root/Game/Enemies")
onready var scone_gain_message_resource = load("res://HUD/ScoreGainMessage.tscn")

export var font_min_size : int = 30
export var font_max_size : int = 50
export var font_scale_speed : int = 20

var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.connect("enemy_died", self, "_on_enemy_died")
	get_font("font").size = font_min_size

func _physics_process(delta):
	if get_font("font").size > font_min_size:
		get_font("font").size -= font_scale_speed*delta
	else :
		get_font("font").size = font_min_size

func _on_enemy_died(position, score_gained,color):
	#Update score
	score += score_gained
	
	#Show a message where the enemy died
	var message = scone_gain_message_resource.instance()
	message.init("+"+str(score_gained), position, get_position(),color)
	get_parent().add_child(message)
	yield(message,"goal_reached")
	
	#Update scorelabel
	set_text(str(score))
	get_font("font").size = score_gained/2
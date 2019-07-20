extends Label

onready var enemy : KinematicBody2D = get_node("/root/Game/Characters/Enemies")
onready var game : KinematicBody2D = get_node("/root/Game")
onready var scone_gain_message_resource = load("res://HUD/ScoreGainMessage.tscn")

export var font_min_size : int = 40
export var font_max_size : int = 100
export var font_scale_speed : int = 60
export var font_scale_delay : int = 0.05

var score : int = 0
var multiplier : int = 1

var font_scale_timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	font_scale_timer.set_one_shot(true)
	font_scale_timer.set_wait_time(font_scale_delay)
	font_scale_timer.connect("timeout",self,"_on_font_scale_timeout")
	add_child(font_scale_timer)
	
	enemy.connect("enemy_died", self, "_on_enemy_died")
	game.connect("multiplier_set", self, "_on_multiplier_set")
	get_font("font").size = font_min_size
	set_physics_process(false)

func _physics_process(delta):
	if get_font("font").size > font_min_size:
		get_font("font").size -= font_scale_speed*delta
	else :
		get_font("font").size = font_min_size
		set_physics_process(false)

func _on_enemy_died(position, score_gained,color):
	
	#Show a message where the enemy died
	var message = scone_gain_message_resource.instance()
	message.init("+"+str(score_gained*multiplier),position, get_parent().get_parent().get_rect().position,color)
	get_parent().get_parent().get_parent().add_child(message)
	yield(message,"goal_reached")
	
	#Update score
	score += score_gained*multiplier
	
	#Update scorelabel
	set_text(str(score))
	get_font("font").size = score_gained/2
	set_physics_process(false)
	font_scale_timer.start()
	
func _on_multiplier_set(multiplier):
	self.multiplier = multiplier
	
func _on_font_scale_timeout():
	set_physics_process(true)
extends Node2D

signal tainted()
signal pigmented()
signal colourful()
signal chromatic()
signal combo_broken()
signal multiplier_set(multiplier)

onready var player = get_node("/root/Game/Player")

export var tainted_threshold = 2
export var pigmented_threshold = 4
export var colourful_threshold = 6
export var chromatic_threshold = 10

enum COMBO {
	NONE,
	TAINTED,
	PIGMENTED,
	COLOURFUL,
	CHROMATIC
}

var multiplier : Dictionary = {COMBO.NONE : 1, COMBO.TAINTED : 2, COMBO.PIGMENTED : 3, COMBO.COLOURFUL : 4, COMBO.CHROMATIC : 6}
var combo_signals : Dictionary = {COMBO.NONE : "combo_broken", COMBO.TAINTED : "tainted", COMBO.PIGMENTED : "pigmented", COMBO.COLOURFUL : "colourful", COMBO.CHROMATIC : "chromatic"}

var score = 0
var combo_length = 0
var combo_score = 0
var combo = COMBO.NONE

func _ready():
	get_tree().paused = false

func _process(delta):
	var combo_changed : bool = false
	
	if player.jauges.min() < chromatic_threshold and combo == COMBO.CHROMATIC:
		combo = COMBO.COLOURFUL
		combo_changed = true
	if player.jauges.min() < colourful_threshold and combo == COMBO.COLOURFUL:
		combo = COMBO.PIGMENTED
		combo_changed = true
	if player.jauges.min() < pigmented_threshold and combo == COMBO.PIGMENTED:
		combo = COMBO.TAINTED
		combo_changed = true
	if player.jauges.min() < tainted_threshold and combo == COMBO.TAINTED:
		combo = COMBO.NONE
		combo_changed = true

	if player.jauges.min() >= tainted_threshold and combo == COMBO.NONE:
		combo = COMBO.TAINTED
		combo_changed = true
	if player.jauges.min() >= pigmented_threshold and combo == COMBO.TAINTED:
		combo = COMBO.PIGMENTED
		combo_changed = true
	if player.jauges.min() >= colourful_threshold and combo == COMBO.PIGMENTED:
		combo = COMBO.COLOURFUL
		combo_changed = true
	if player.jauges.min() >= chromatic_threshold and combo == COMBO.COLOURFUL:
		combo = COMBO.CHROMATIC
		combo_changed = true
	
	if combo_changed :
		emit_signal(combo_signals[combo])
		emit_signal("multiplier_set",multiplier[combo])

func _on_Enemies_enemy_died(position, score_gained,color):
	#Updating the score
	score += score_gained * multiplier[combo]
	
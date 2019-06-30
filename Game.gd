extends Node2D

signal tainted()
signal pigmented()
signal colourful()
signal chromatic()
signal combo_broken()
signal multiplier_set(multiplier)

export var last_combo_time = 0
export var time_to_break_combo = 5000

export var tainted_threshold = 200
export var pigmented_threshold = 1000
export var colourful_threshold = 2000
export var chromatic_threshold = 4000

enum COMBO {
	NONE,
	TAINTED,
	PIGMENTED,
	COLOURFUL,
	CHROMATIC
}

var multiplier : Dictionary = {COMBO.NONE : 1, COMBO.TAINTED : 2, COMBO.PIGMENTED : 3, COMBO.COLOURFUL : 4, COMBO.CHROMATIC : 6}

var score = 0
var combo_length = 0
var combo_score = 0
var combo = COMBO.NONE

func _process(delta):
	var current_time = OS.get_ticks_msec()
	if (current_time - last_combo_time) > time_to_break_combo :
		combo_length = 0
		combo_score = 0
		combo = COMBO.NONE
		emit_signal("combo_broken")
		emit_signal("multiplier_set",multiplier[combo])

func _on_Enemies_enemy_died(position, score_gained,color):
	#Updating the score
	score += score_gained * multiplier[combo]
	
	#Check if the player is in a combo (= killing ennemies under a time limit)
	var current_time = OS.get_ticks_msec()
	if last_combo_time == 0:
		last_combo_time = current_time
		
	if (current_time - last_combo_time) <= time_to_break_combo :
		combo_length += 1
		combo_score += score_gained * multiplier[combo]
	else :
		combo_length = 0
		combo_score = 0
		combo = COMBO.NONE
		emit_signal("combo_broken")
		emit_signal("multiplier_set",multiplier[combo])
	
	last_combo_time = current_time
	
	# The combo level increases
	if combo_score >= chromatic_threshold :
		if combo != COMBO.CHROMATIC:
			combo = COMBO.CHROMATIC
			emit_signal("chromatic")
			emit_signal("multiplier_set",multiplier[combo])
	elif combo_score >= colourful_threshold:
		if combo != COMBO.COLOURFUL:
			combo = COMBO.COLOURFUL
			emit_signal("colourful")
			emit_signal("multiplier_set",multiplier[combo])
	elif combo_score >= pigmented_threshold:
		if combo != COMBO.PIGMENTED:
			combo = COMBO.PIGMENTED
			emit_signal("pigmented")
			emit_signal("multiplier_set",multiplier[combo])
	elif combo_score >= tainted_threshold:
		if combo != COMBO.TAINTED:
			combo = COMBO.TAINTED
			emit_signal("tainted")
			emit_signal("multiplier_set",multiplier[combo])
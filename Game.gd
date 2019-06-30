extends Node2D

var score = 0

signal tainted()
signal pigmented()
signal colourful()
signal chromatic()
signal combo_broken()



var combo_length = 0
var combo_score = 0

export var last_combo_time = 0
export var time_to_break_combo = 5000

export var tainted_threshold = 200
export var pigmented_threshold = 300
export var colourful_threshold = 400
export var chromatic_threshold = 500
func _process(delta):
	pass

func _on_Enemies_enemy_died(position, score_gained):
	#Updating the score
	score += score_gained
	
	#Check if the player is in a combo (= killing ennemies under a time limit)
	var current_time = OS.get_ticks_msec()
	if last_combo_time == 0:
		last_combo_time = current_time
		
	print (current_time - last_combo_time)
	if (current_time - last_combo_time) <= time_to_break_combo :
		combo_length += 1
		combo_score += score_gained
	else :
		combo_length = 0
		combo_score = 0
		emit_signal("combo_broken")
	
	last_combo_time = current_time
	
	# The combo level increases
	if combo_score >= chromatic_threshold:
		emit_signal("chromatic")
	elif combo_score >= colourful_threshold:
		emit_signal("colourful")
	elif combo_score >= pigmented_threshold:
		emit_signal("pigmented")
	elif combo_score >= tainted_threshold:
		emit_signal("tainted")
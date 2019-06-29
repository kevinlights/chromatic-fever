extends Label

var sounds_node = null

var hue_timer = 0
var hue_speed = 60 #degrees per second

var is_scaling_up = true
var scale_factor = 0.5
var scale_upper_limit = 1.5
var scale_lower_limit = 1

func _ready():
	sounds_node = get_parent().get_parent().get_node("Sounds");
	hide()
	show_message("PIGMENTED")

func _process(delta):
	#Hue
	hue_timer = fmod(hue_timer + delta * hue_speed, 360)
	var h = hue_timer / 360 #h,s,v needs to be in range 0-1
	
	var new_color = Color()
	new_color.v = 1 
	new_color.s = 1 
	new_color.h = h

	set("custom_colors/font_color", new_color)
	
	#Scale
	var scale_value = get_scale().x
	var position = get_position()
	
	if is_scaling_up: 
		scale_value = scale_value + scale_factor * delta
		if scale_value >= scale_upper_limit:
			is_scaling_up = false
		position.x -= scale_factor
		position.y -= scale_factor
	else:
		scale_value = scale_value - scale_factor * delta
		if scale_value <= scale_lower_limit:
			is_scaling_up = true
		position.x += scale_factor
		position.y += scale_factor
		
	set_scale(Vector2(scale_value,scale_value))
	set_position(Vector2(position.x,position.y))

func show_message(message):
	show()
	sounds_node.get_node(message).play();
	set_text(message);
	yield(get_tree().create_timer(2.5), "timeout")
	hide()
	

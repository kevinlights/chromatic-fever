extends Label

var hue_timer = 0
var hue_speed = 60 #degrees per second

var initial_scale = 1
var initial_position = 1
#var is_scaling_up = true
var scale_factor = 0.5
var position_factor = 100
#var scale_upper_limit = initial_scale + (scale_factor * 4)
#var scale_lower_limit = initial_scale - (scale_factor * 2)

onready var sound_object = $Sounds/NULL

func _ready():
	pass

func init(scale, position):
	initial_scale = scale
	set_scale(Vector2(initial_scale, initial_scale))
	initial_position = position
	set_position(Vector2(initial_position.x, initial_position.y))
	
func set_sound_object(sound_object_name):
	match sound_object_name:
		"TAINTED": 
			sound_object = $Sounds/TAINTED
		"PIGMENTED":
			sound_object = $Sounds/PIGMENTED
		"COLOURFUL":
			sound_object = $Sounds/COLOURFUL
		"CHROMATIC":
			sound_object = $Sounds/CHROMATIC

func _process(delta):
	#Hue
	hue_timer = fmod(hue_timer + delta * hue_speed, 360)
	var h = hue_timer / 360 #h,s,v needs to be in range 0-1
	
	"""
	var new_color = Color()
	new_color.v = 1 
	new_color.s = 1 
	new_color.h = h

	set("custom_colors/font_color", new_color)
	"""
	#Scale
	var scale_value = get_scale().x + delta * scale_factor
	var position = get_position()
	
	#if is_scaling_up: 
	#scale_value = scale_value + scale_factor * delta
	#if scale_value >= scale_upper_limit:
	#	is_scaling_up = false
	#position.x -= scale_factor
	#position.y -= scale_factor
	#else:
	#	scale_value = scale_value - scale_factor * delta
	#	if scale_value <= scale_lower_limit:
	#		is_scaling_up = true
	#	position.x += scale_factor
	#	position.y += scale_factor
		
	set_scale(Vector2(scale_value,scale_value ))
	set_position(Vector2(position.x - scale_factor, position.y - delta * position_factor))

func write_message(message):
	show()
	sound_object.play()
	set_text(message)
	
	var t = Timer.new()
	t.set_wait_time(1.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	hide()
	

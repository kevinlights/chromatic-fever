"""
Licensed under GPL-3.0-or-later
Copyright (C) 2019 Louka Soret

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

extends Label

onready var sound_object = $Sounds/NULL
onready var chromatic_aberation = get_node("/root/Game/HUD/ChromaticAberation")
onready var anim = get_node("../AnimationPlayer")

#export var store_font_size : int = 30 
export var store_speed : int = 1250
export var store_font_speed : int = 60

var hue_timer = 0
var hue_speed = 60 #degrees per second

var store_direction : Vector2 
var store_position : Vector2 = Vector2(1000,21)

#var initial_font_size =	60
var initial_position = 1
#var is_scaling_up = true
var scale_factor = 0.5
var position_factor = 100
#var scale_upper_limit = initial_scale + (scale_factor * 4)
#var scale_lower_limit = initial_scale - (scale_factor * 2)

var store : bool = false

func _ready():
	#get_font("font").size = initial_font_size
	chromatic_aberation.material.set_shader_param("scale",0.01)

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
	
	if store :
		var new_direction : Vector2
		
		set_position(get_position() + store_speed*delta*store_direction)
		
		"""if get_font("font").size > store_font_size:
			get_font("font").size -= store_font_speed*delta
		else :
			get_font("font").size = store_font_size
		"""
		new_direction = (store_position - get_position()).normalized()
		
		if store_direction.x > 0 and new_direction.x <= 0 or store_direction.x < 0 and new_direction.x >= 0 or store_direction.y > 0 and new_direction.y <= 0 or store_direction.y < 0 and new_direction.y >= 0 :
			chromatic_aberation.material.set_shader_param("scale",0.0)
			set_process(false)
	else:
		
		#Hue
		hue_timer = fmod(hue_timer + delta * hue_speed, 360)
		var h = hue_timer / 360 #h,s,v needs to be in range 0-1
		#Scale
		#var scale_value = get_scale().x + delta * scale_factor
		var position = get_position()
		#set_scale(Vector2(scale_value,scale_value ))
		set_position(Vector2(position.x, position.y - delta * position_factor))

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
		

func write_message(message):
	show()
	sound_object.play()
	set_text(message)
	set_position(Vector2(get_position().x- (get_total_character_count()*40)/2, get_position().y))
	store_position.x -= get_total_character_count()*23
	var t = Timer.new()
	t.set_wait_time(1.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	anim.play("gros")
	anim.seek(0)
	store_direction = get_position().direction_to(store_position)
	store = true

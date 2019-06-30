extends Label

signal goal_reached()

export var speed : int = 500
export var font_min_size : int = 10
export var font_max_size : int = 30
export var font_scale_speed : int = 80

var target : Vector2
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(msg : String, start : Vector2, goal : Vector2, color : Color):
	set_text(msg)
	set_position(start)
	direction = (goal - start).normalized()
	add_color_override("font_color",color)
	get_font("font").size = font_min_size
	target = goal

func _process(delta):
	var new_direction : Vector2
	
	set_position(get_position() + speed*delta*direction)
	if get_font("font").size < font_max_size:
		get_font("font").size += font_scale_speed*delta
	else :
		get_font("font").size = font_max_size
	
	new_direction = (target - get_position()).normalized()
	
	if direction.x > 0 and new_direction.x <= 0 or direction.x < 0 and new_direction.x >= 0 or direction.y > 0 and new_direction.y <= 0 or direction.y < 0 and new_direction.y >= 0 :
		get_parent().remove_child(self)
		emit_signal("goal_reached")
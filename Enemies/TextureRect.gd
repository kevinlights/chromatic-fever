extends TextureRect

var is_full = true

func _ready():
	pass;

func set_full():
	is_full = true
	self.texture = load("res://HUD/Images/heart_full.png")
	
func set_empty():
	is_full = false
	self.texture = load("res://HUD/Images/heart_empty.png")
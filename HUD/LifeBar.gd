extends HBoxContainer

onready var player : KinematicBody2D = get_node("/root/Game/Player")
var heart_array : Array = []

func _ready():
	# Creating the heart pictures
	heart_array.append($Heart)
	for i in range(player.max_health-1):
		var newHeart = $Heart.duplicate()
		heart_array.append(newHeart)
		add_child(newHeart)
		
	# Signal connection
	player.connect("player_hit", self, "_on_player_hit")
	player.connect("player_die", self, "_on_player_die")

func find_last_full_heart():
	var i = heart_array.size()-1
	var heart = heart_array[i]
	while i < 0 || !heart_array[i].is_full :
		i -= 1

	if i > 0:
		return heart_array[i]
		
func _on_player_hit():
	var heart = find_last_full_heart()
	if heart:
		heart.set_empty()

func _on_player_die():
	hide()
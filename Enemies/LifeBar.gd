extends HBoxContainer

onready var enemy = get_parent()
var heart_array : Array = []

func _ready():
	# Creating the heart pictures
	heart_array.append($Heart)
	for i in range(enemy.max_health-1):
		var newHeart = $Heart.duplicate()
		heart_array.append(newHeart)
		add_child(newHeart)
	
	# Signal connection
	enemy.connect("enemy_hit", self, "_on_enemy_hit")

func find_last_full_heart():
	var i = heart_array.size()-1
	while i < 0 || !heart_array[i].is_full :
		i -= 1
	
	if i >= 0:
		return heart_array[i]

func _on_enemy_hit(dmg):
	var heart
	for i in dmg:
		heart = find_last_full_heart()
		if heart:
			heart.set_empty()
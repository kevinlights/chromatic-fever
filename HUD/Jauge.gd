extends TextureProgress

onready var player = get_node("/root/Game/Characters/Player")
onready var global = get_node("/root/Global")


export var jauge_number : int 

func _ready():
	modulate = global.colors[jauge_number]
	max_value = player.max_jauge

func _process(delta):
	set_value(player.jauges[jauge_number])
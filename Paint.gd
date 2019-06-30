extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tache = load("res://peintures/peinture1.tscn")
onready var eff = load("res://peintures/effacement1.tscn")
onready var vp_c : Viewport = get_node("Viewport_couleurs")
onready var vp_e = get_node("Viewport_effacements")
onready var feuille = get_node("/root/Game/Terrain/Feuille")

# Called when the node enters the scene tree for the first time.
func _ready(): 
	$Viewport_couleurs.size = feuille.texture.get_size()
	$Viewport_effacements.size = feuille.texture.get_size()
	$Sprite.position = feuille.texture.get_size()/2
	#set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	"""
	if(Input.is_action_pressed("clic_gauche")):
		spawn_peinture(get_global_mouse_position(),Color(1,0,0))
	if(Input.is_action_pressed("clic_droit")):
		spawn_effacement(get_global_mouse_position())
	"""

func spawn_peinture(position,couleur):
	var i = tache.instance()
	vp_c.add_child(i)
	i.set_position(position)
	i.modulate = couleur
	var i2 = tache.instance()
	vp_e.add_child(i2)
	i2.modulate = Color(0,0,0)
	i2.set_position(position)
	i2.z_index=1
	vp_c.set_update_mode(Viewport.UPDATE_ONCE)
	vp_e.set_update_mode(Viewport.UPDATE_ONCE)
	
func spawn_effacement(position):
	var i2 = tache.instance()
	vp_e.add_child(i2)
	i2.modulate = Color(1,1,1)
	i2.set_position(position)
	i2.z_index=1
	vp_e.set_update_mode(Viewport.UPDATE_ONCE)

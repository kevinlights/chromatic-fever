extends Area2D

class_name Projectile

onready var enemies : Node2D = get_node("/root/Game/Characters/Enemies")
onready var terrain = get_node("/root/Game/Terrain/Feuille")
onready var player : Sprite = get_node("/root/Game/Characters/Player/LesSprites/heros_couleur")
onready var game = get_node("/root/Game")

export var speed1 : int = 1500
export var speed2 : int = 500
export var explosive_extents : Vector2 = Vector2(4,4)

var explosive : bool = false

var direction : Vector2
var veloctity : Vector2
var speed = 500

func _ready():
	$bullet1.modulate = player.modulate
	speed = speed1
	if(game.combo == game.COMBO.CHROMATIC):
		$bullet1.visible = false
		$bullet2.visible = true
		$bullet2.modulate = player.modulate
		speed = speed2
	$Explosion/SpashLittleClear.process_material.color = player.modulate
	$Explosion/SplashLittleDark.process_material.color = player.modulate
	$Explosion/SplashBigClear.process_material.color = player.modulate-Color(0.5,0.5,0.5,0)
	$Explosion/SplashBigDark.process_material.color = player.modulate-Color(0.5,0.5,0.5,0)

func _physics_process(delta):
	veloctity = direction*speed
	global_position += veloctity*delta

func make_connections():
	for hb in get_tree().get_nodes_in_group("projectile_collisions"):
			connect("area_entered",hb,"_on_projectile_hit_e")
	connect("area_entered",self,"_on_projectile_hit")
	$AnimationPlayer.play("gros")

func explode():
	speed=0
	$CollisionShape2D.scale = explosive_extents
	explosive = false
	var n = $Explosion
	$Explosion/AnimationPlayer.play("explosion")
	remove_child(n)
	game.add_child(n)
	n.position = position

func _on_projectile_hit(area : Area2D):
	if self != null and get_parent() != null:
		if explosive:
			explode()
			$bullet1.hide()
			yield(get_tree().create_timer(0.5),"timeout")
		self.queue_free()
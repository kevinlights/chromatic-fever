extends Camera2D

#Shake configuration
export var shake_amplitude : Vector2 = Vector2(6,6)
export(float, EASE) var SHAKE_DAMP_EASING = 1.0

# Shake vars
var shake : bool = false
var shake_timer : Timer = Timer.new()
var shake_duration : float = 0.8 # sec

func _ready():
	randomize()
	shake_timer.set_one_shot(true)
	shake_timer.set_wait_time(shake_duration)
	shake_timer.connect("timeout",self,"_on_shake_timeout")
	add_child(shake_timer)

func _process(delta):
	if shake:
		var damping = ease(shake_timer.time_left/shake_timer.wait_time,SHAKE_DAMP_EASING)
		offset = Vector2(rand_range(shake_amplitude.x,-shake_amplitude.x),rand_range(shake_amplitude.y,-shake_amplitude.y))
		offset *= damping

func _on_shake_timeout():
	shake = false
	
func _camera_shake(duration : float):
	shake_duration = duration
	shake_timer.wait_time = shake_duration
	shake = true
	shake_timer.start()
	
func _camera_freeze(duration : float):
	OS.delay_msec(duration*100)
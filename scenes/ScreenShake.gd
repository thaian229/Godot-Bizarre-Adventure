extends Node2D

var _current_shake_priority := 0

onready var strength_tween := $Tween as Tween
onready var camera := get_node("%Player").get_node("MainCamera") as Camera2D

func shake_screen(duration: float, strength: float, priority: int) -> void:
	if priority < _current_shake_priority:
		return
	_current_shake_priority = priority
	if not strength_tween.interpolate_method(self, "_move_camera", Vector2(strength, strength),
			Vector2.ZERO, duration, Tween.TRANS_SINE, Tween.EASE_OUT):
		return
	if not strength_tween.start():
		print("Error in tween")


func _move_camera(vec: Vector2) -> void:
	camera.offset = Vector2(rand_range(-vec.x, vec.x), rand_range(-vec.y, vec.y))

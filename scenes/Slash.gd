class_name Slash
extends Area2D
# A slash ranged-attack of character
# Auto move forward horizontally

export(int, 0, 1000) var move_speed := 120
export(int, 0, 600) var attack_range := 320

var _velocity := Vector2.ZERO
var _flipped := false

onready var animation := $AnimatedSprite as AnimatedSprite


func _ready():
	animation.flip_h = _flipped
	animation.play("default")


func _physics_process(delta: float):
	if _flipped:
		_velocity.x = - move_speed * delta
		animation.flip_h = true
	else:
		_velocity.x = move_speed * delta
		animation.flip_h = false
	translate(_velocity)
	animation.play("default")
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Slash_body_entered(_body: Node):
	call_deferred("queue_free")


func set_direction(is_flipped: bool = false) -> void:
	_flipped = is_flipped
	return


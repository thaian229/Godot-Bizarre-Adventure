class_name Slash
extends Area2D
# A slash ranged-attack of character
# Auto move forward horizontally

export(int, 0, 1000) var move_speed := 120
export(int, 0, 600) var attack_range := 320
export(int, 1, 3) var attack_damage := 1

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


func _on_Slash_body_entered(body: Node):
	# handle enemy collide
	if body.is_in_group("enemy"):
		var enemy: Enemy = body as Enemy
		enemy.take_damage(attack_damage)
	call_deferred("queue_free")


func set_direction(is_flipped: bool = false) -> void:
	_flipped = is_flipped
	return

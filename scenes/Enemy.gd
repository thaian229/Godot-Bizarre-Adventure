class_name Enemy
extends KinematicBody2D
# Simple, base enemy entity

export(int, 0, 200) var speed := 30
export(int, 0, 500) var gravity := 200

var _direction := Vector2.ZERO
var _velocity := Vector2.ZERO

onready var animation := $AnimatedSprite as AnimatedSprite
onready var ground_check := $RayCast2D as RayCast2D
onready var screen_size := get_viewport_rect().size

func _ready():
	_direction.x = -1
	ground_check.position.x = -abs(ground_check.position.x)

func _physics_process(delta: float) -> void:
	# update move
	self._update_move(delta)
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
	# Prevent player go out of viewport
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _update_move(delta: float) -> void:
	# turn on contracting walls or ledges
	if is_on_wall() or not ground_check.is_colliding():
		_direction.x *= -1
		ground_check.position.x *= -1
	
	_velocity.x = speed * _direction.x
	_velocity.y += gravity * delta
	
	animation.flip_h = _direction.x < 0
	animation.play("walk")

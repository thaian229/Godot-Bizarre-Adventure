class_name Player
extends KinematicBody2D
# class for Player entity
# Player can move, jump, shoot

# Editable
export(int, 0, 200) var speed := 60
export(int, 0, 300) var jump_speed := 120
export(int, 0, 500) var gravity := 200

# private use
var _direction := Vector2.ZERO
var _velocity := Vector2.ZERO

# children
onready var animation := $AnimatedSprite as AnimatedSprite

func _physics_process(delta: float):
	# handle move horizontally
	self._move_update()
	# handle move vertically
	self._jump_update(delta)
	
	_velocity = move_and_slide(_velocity, Vector2.UP)


func _move_update() -> void:
	# read input to get move direction
	_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		_direction.x += 1
	
	_velocity.x = _direction.x * speed
	
	# handle animation
	if _direction.x != 0:
		animation.flip_h = _direction.x < 0
		animation.play("walk")
	else:
		animation.stop()
	
	return


func _jump_update(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_velocity.y = -jump_speed
	
	_velocity.y += gravity * delta
	return


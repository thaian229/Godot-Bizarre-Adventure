class_name Player
extends KinematicBody2D
# class for Player entity
# Player can move, jump, shoot

# Editable
export(int, 0, 200) var speed := 60
export(int, 0, 300) var jump_speed := 120
export(int, 0, 500) var gravity := 200

export(PackedScene) var slash_prefab = preload("res://scenes/Slash.tscn")

# private use
var _direction := Vector2.ZERO
var _velocity := Vector2.ZERO
var _attacking := false

# children
onready var animation := $AnimatedSprite as AnimatedSprite
onready var muzzle := $ProjectilePosition2D as Position2D
onready	var screen_size := get_viewport_rect().size

func _physics_process(delta: float):
	# handle move horizontally and muzzle position
	self._move_update()
	# handle move vertically
	self._jump_update(delta)
	
	_velocity = move_and_slide(_velocity, Vector2.UP)
	# Prevent player go out of viewport
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# animation for basic movement
	self._change_move_animation()
	# handle attack
	self._handle_attack()


func _on_AnimatedSprite_animation_finished():
	_attacking = false


func _move_update() -> void:
	# read input to get move direction
	_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		_direction.x -= 1
		muzzle.position.x = -abs(muzzle.position.x)
	if Input.is_action_pressed("move_right"):
		_direction.x += 1
		muzzle.position.x = +abs(muzzle.position.x)
	
	_velocity.x = _direction.x * speed


func _jump_update(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_velocity.y = -jump_speed
	
	_velocity.y += gravity * delta


func _change_move_animation() -> void:
	# triggered animations override basic movement animations
	if _attacking:
		return
	
	if _velocity == Vector2.ZERO:
		animation.play("idle")
	
	# handle flip
	if _velocity.x != 0:
		animation.flip_h = _velocity.x < 0
		if is_on_floor():
			animation.play("run")
	
	# handle jump and fall
	if _velocity.y != 0 and not is_on_floor():
		if _velocity.y < 0:
			animation.play("jump")
		else:
			animation.play("fall")


func _handle_attack() -> void:
	if Input.is_action_just_pressed("attack") and not _attacking:
		var slash: Slash = slash_prefab.instance()
		if not slash:
			return
		_attacking = true
		animation.play("attack")
		slash.set_direction(animation.flip_h)
		slash.position = muzzle.global_position
		get_tree().root.add_child(slash)

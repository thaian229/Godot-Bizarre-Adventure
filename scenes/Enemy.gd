class_name Enemy
extends KinematicBody2D
# Simple, base enemy entity

signal die

export(int, 0, 200) var speed := 30
export(int, 0, 500) var gravity := 200

var is_dead := false

var _direction := Vector2.ZERO
var _velocity := Vector2.ZERO

onready var animation := $AnimatedSprite as AnimatedSprite
onready var ground_check := $RayCast2D as RayCast2D
onready var death_timer := $DecayTimer as Timer
onready var collider := $CollisionShape2D as CollisionShape2D
onready var screen_size := get_viewport_rect().size


func _ready():
	_direction.x = -1
	ground_check.position.x = -abs(ground_check.position.x)


func _physics_process(delta: float) -> void:
	# update move
	self._update_move(delta)
	_velocity = move_and_slide(_velocity, Vector2.UP)


func _on_DecayTimer_timeout():
	call_deferred("queue_free")


func _update_move(delta: float) -> void:
	# turn on contracting walls or ledges
	if is_on_wall() or not ground_check.is_colliding():
		_direction.x *= -1
		ground_check.position.x *= -1
	
	_velocity.x = speed * _direction.x
	_velocity.y += gravity * delta
	
	animation.flip_h = _direction.x < 0
	animation.play("walk")


func dead() -> void:
	if is_dead:
		return
	is_dead = true
	# freeze
	set_physics_process(false)
	# turn off collider --> can pass
	collider.set_deferred("disabled", true)
	animation.play("dead")
	# just in-case manager class need to keep track
	emit_signal("die")
	# schedule destroy
	death_timer.start()

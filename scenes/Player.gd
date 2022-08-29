extends KinematicBody2D

# editable
export var speed = 60
export var jump_speed = -120
export var gravity = 200

const FLOOR_NORMAL = Vector2(0, -1)

# internal use
var direction = Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(delta):
	# read input to get move direction
	direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	velocity.x = direction.x * speed
	
	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
	velocity.y += gravity * delta
	
	# handle animation
	if direction.x != 0:
		$AnimatedSprite.flip_h = direction.x < 0
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.stop()
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

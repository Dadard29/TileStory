extends KinematicBody2D

export var GRAVITY = 2000
export var SPEED = Vector2(400, 800)
export var ENERGY = 0

var FLOOR_NORMAL = Vector2.UP
var _velocity = Vector2.ZERO
var _moving = false

const ENERGY_SMALL_GROUP = "energy_small"

signal jumped
signal moving
signal idle

func _ready():
	pass # Replace with function body.
	
func get_velocity(linear_velocity, direction, delta):
	var velocity = linear_velocity
	
	
	velocity.x = SPEED.x * direction.x
	if direction.y != 0:
		if is_on_floor():
			# jumping
			velocity.y = SPEED.y * direction.y
		else:
			# falling
			velocity.y += GRAVITY * delta

	var is_jump_interrupted = Input.is_action_just_released("ui_up") and velocity.y < 0
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
		
	return move_and_slide(velocity, FLOOR_NORMAL)
	
	
func get_direction() -> Vector2:
	var direction_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var direction_y = -1 if is_on_floor() and Input.is_action_pressed("ui_up") else 1
	
	return Vector2(direction_x, direction_y)
	

func set_state_signal(direction):
	var _moving_previous = _moving
	_moving = direction.x != 0
	
	# changed state
	if _moving_previous != _moving:
		if _moving:
			emit_signal("moving")
		else:
			emit_signal("idle")
	
#func set_animation(direction: Vector2):
#	var animation = ANIMATION_IDLE
#	if direction.x != 0:
#		animation = ANIMATION_MOVE
#
#	animations.set_animation(animation)
	
#func set_orientation(direction):
#	var flip_h = false
#	if direction.x < 0:
#		flip_h = true
#
#	animations.set_flip_h(flip_h)
	
#func set_signal(direction):
#	if direction.y == -1:
#		position = get_position()
#		emit_signal("jumped", position)
		


func _physics_process(delta):

	var direction = get_direction()
	_velocity = get_velocity(_velocity, direction, delta)
	set_state_signal(direction)
	
	# set_animation(direction)
	# set_orientation(direction)
	# set_signal(direction)

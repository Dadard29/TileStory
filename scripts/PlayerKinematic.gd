extends KinematicBody2D

export var GRAVITY = 2000
export var SPEED = Vector2(400, 800)
export var ENERGY = 0

const ENERGY_GROUP = "energy"
const ENERGY_SMALL_GROUP = "energy_small"
const ENERGY_MEDIUM_GROUP = "energy_medium"

var FLOOR_NORMAL = Vector2.UP
var _velocity = Vector2.ZERO
var _moving = false

onready var anim = $Animations

signal jumped
signal energy_changed

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
	

func set_animations(direction):
	var _moving_previous = _moving
	_moving = direction.x != 0
	
	# changed state
	if _moving_previous != _moving:
		if _moving:
			if direction.x < 0:
				anim.move_left()
			else:
				anim.move_right()
		else:
			anim.idle()
	
	if direction.y == -1:
		var position = get_global_position()
		emit_signal("jumped", position)

func _physics_process(delta):

	var direction = get_direction()
	_velocity = get_velocity(_velocity, direction, delta)
	set_animations(direction)


func _on_DetectionArea_area_entered(area: Area2D):
	if area.is_in_group(ENERGY_GROUP):
		emit_signal("energy_changed", area)

	if area.is_in_group(ENERGY_SMALL_GROUP):
		print("detected energy small")
		emit_signal("energy_changed")
	elif area.is_in_group(ENERGY_MEDIUM_GROUP):
		print("detected energy medium")
		emit_signal("energy_changed")

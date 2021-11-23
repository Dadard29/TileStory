extends KinematicBody2D

export var GRAVITY = 2000
export var SPEED_SIDE = 400
export var SPEED_JUMP = 800

export var FLOOR_NORMAL = Vector2.UP

const ENERGY_GROUP = "energy"
var _velocity = Vector2.ZERO
var _moving = false

onready var anim = $Animations

signal jumped
signal energy_changed

var orients = preload("res://scripts/Orientations.gd")

func _ready():
	pass
	

func _get_is_jump_interrupted(velocity: Vector2) -> bool:
	# var control = Input.is_action_just_released("ui_up")
	var control = Input.is_action_just_released("ui_right")
	var velocity_jump: bool
	if FLOOR_NORMAL == Vector2.UP:
		velocity_jump = velocity.y < 0
		
	elif FLOOR_NORMAL == Vector2.DOWN:
		velocity_jump = velocity.y > 0
	
	elif FLOOR_NORMAL == Vector2.RIGHT:
		velocity_jump = velocity.x > 0
	
	return control and velocity_jump
		
func _get_velocity_up_down(linear_velocity: Vector2, direction, delta):
	var velocity = linear_velocity
	
	velocity.x = SPEED_SIDE * direction.x
	if direction.y != 0:
		if is_on_floor():
			# jumping
			velocity.y = -SPEED_JUMP * direction.y * FLOOR_NORMAL.y
		else:
			# falling
			velocity.y += -GRAVITY * delta * FLOOR_NORMAL.y
			
	return velocity
	
func _get_velocity_left_right(linear_velocity: Vector2, direction, delta):
	var velocity = linear_velocity
	
	velocity.y = SPEED_SIDE * direction.y
	if direction.x != 0:
		if is_on_floor():
			# jumping
			velocity.x = SPEED_JUMP * direction.x * FLOOR_NORMAL.x
		else:
			# falling
			velocity.x += -GRAVITY * delta * FLOOR_NORMAL.x
			
	return velocity
	
	
func get_velocity(linear_velocity, direction, delta):
	var velocity: Vector2
	
	if FLOOR_NORMAL == Vector2.UP or FLOOR_NORMAL == Vector2.DOWN:
		velocity = _get_velocity_up_down(linear_velocity, direction, delta)

	elif FLOOR_NORMAL == Vector2.RIGHT or FLOOR_NORMAL == Vector2.LEFT:
		velocity = _get_velocity_left_right(linear_velocity, direction, delta)

	var is_jump_interrupted = _get_is_jump_interrupted(velocity)
	if is_jump_interrupted:
		velocity.y *= 0.6
	
	return velocity
		
func update_velocity(linear_velocity: Vector2) -> Vector2:		
	return move_and_slide(linear_velocity, FLOOR_NORMAL)
	
	
func get_direction() -> Vector2:
	var direction_x: float
	var direction_y: float
	
	if FLOOR_NORMAL == Vector2.UP or FLOOR_NORMAL == Vector2.DOWN:
		direction_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		direction_y = -1 if is_on_floor() and Input.is_action_pressed("ui_up") else 1

	elif FLOOR_NORMAL == Vector2.LEFT or FLOOR_NORMAL == Vector2.RIGHT:
		direction_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		direction_x = 1 if is_on_floor() and Input.is_action_pressed("ui_right") else -1
	
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

# main loop
func _physics_process(delta):

	var direction = get_direction()
	_velocity = get_velocity(_velocity, direction, delta)
	_velocity = update_velocity(_velocity)
	set_animations(direction)


func _on_DetectionArea_area_entered(area: Area2D):
	if area.is_in_group(ENERGY_GROUP):
		emit_signal("energy_changed", area)

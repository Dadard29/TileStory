extends KinematicBody2D

export var GRAVITY = 1500
export var SPEED_SIDE = 400
export var SPEED_JUMP = 800

const ENERGY_GROUP = "energy"
var _velocity = Vector2.ZERO
var _moving = false

onready var anim = $Animations

signal jumped
signal energy_changed

const ORIENT_T = preload("res://scripts/classes/OrientationsType.gd").ORIENT_TYPE
const VELOCITY_C = preload("res://scripts/classes/Velocity.gd").VELOCITY_CLASS
var velocity

const DIRECTION_C = preload("res://scripts/classes/Direction.gd").DIRECTION_CLASS
var direction

export(ORIENT_T) var DEFAULT_ORIENT_TYPE = ORIENT_T.UP

func _ready():
	self.velocity = VELOCITY_C.new(
		DEFAULT_ORIENT_TYPE,
		SPEED_SIDE,
		SPEED_JUMP,
		GRAVITY
	)
	
	self.direction = DIRECTION_C.new(
		DEFAULT_ORIENT_TYPE
	)

# main loop
func _physics_process(delta):
	if self.velocity.is_in_the_air_almost_stopped(_velocity, 600, is_on_floor()):
		self.set_modulate(Color.black)
	else:
		self.set_modulate(Color.white)
		
		# self.velocity.speed_slow(0.05)
	
#	if Input.is_action_just_pressed("ui_accept"):
#
#	elif Input.is_action_just_released("ui_accept"):
#		print("released")
#		self.velocity.speed_reset()
	
	# compute direction
	var _direction = self.direction.get_direction(is_on_floor())
	
	# compute velocity
	self._velocity = self.velocity.get_velocity(
		self._velocity, _direction, delta, is_on_floor()
	)
	
	# apply slow if key has been released during jump
	if self.direction.is_jump_interrupted(self.velocity.is_jumping(_velocity)):
		self._velocity = self.velocity.apply_jump_interruption(self._velocity)
	
	# apply velocity
	var floor_normal = self.velocity.get_floor_normal()
	self._velocity = move_and_slide(self._velocity, floor_normal)
	
	# set animation according to the direction
	self.anim.set_moving_animation(
		self.direction.is_moving(_direction),
		self.direction.is_moving_left(_direction),
		self.direction.is_moving_right(_direction)
	)
	
	if self.direction.is_just_jumped(_direction):
		var position = get_global_position()
		emit_signal("jumped", position)

func _on_DetectionArea_area_entered(area: Area2D):
	if area.is_in_group(ENERGY_GROUP):
		emit_signal("energy_changed", area)

extends KinematicBody2D

# constants
const ENERGY_GROUP = "energy"
const MACHINE_GROUP = "machine"
const TILE_KILL_GROUP = "tile_kill"

# global configurable variables
export var GRAVITY = 1500
export var SPEED_SIDE = 400
export var SPEED_JUMP = 800

# local variables
var _velocity = Vector2.ZERO
var _moving = false
var _switching_gravity = false
var _near_machine = false
var _previous_is_on_floor = true

# child nodes
onready var anim = $Animations
onready var sounds = $Sounds
onready var camera = $Camera

# signals
signal jumped
signal landed
signal energy_found
signal energy_consumed
signal switch_attempt
signal spawned
signal death

# classes
const ORIENT_T = preload("res://scripts/classes/OrientationsType.gd").ORIENT_TYPE
const VELOCITY_C = preload("res://scripts/classes/Velocity.gd").VELOCITY_CLASS
const DIRECTION_C = preload("res://scripts/classes/Direction.gd").DIRECTION_CLASS

# properties
var velocity
var direction
var orient_type

export(ORIENT_T) var DEFAULT_ORIENT_TYPE = ORIENT_T.UP

func _ready():
	self.orient_type = DEFAULT_ORIENT_TYPE
	
	self.velocity = VELOCITY_C.new(
		DEFAULT_ORIENT_TYPE,
		SPEED_SIDE,
		SPEED_JUMP,
		GRAVITY
	)
	
	self.direction = DIRECTION_C.new(
		DEFAULT_ORIENT_TYPE
	)
	
	self.anim.set_orient_type(DEFAULT_ORIENT_TYPE)
	

# =========== MISC ============
func spawn():
	self.anim.set_spawn()
	self.sounds.spawn()

func _on_Animations_animation_finished() -> void:
	if anim.get_animation() == "spawn":
		emit_signal("spawned")
		self.anim.set_idle()
	
	elif anim.get_animation() == "death":
		emit_signal("death")

func zoom():
	camera.loading_zoom()
	
# =========== CONTROLS ========
func is_slow_available(has_enough_energy: bool) -> bool:
	return has_enough_energy and self._switching_gravity and _is_falling_slow()

func is_switch_available(has_enough_energy: bool) -> bool:
	return is_slow_available(has_enough_energy) and self.direction.is_slowing_input()

func is_near_machine() -> bool:
	return _near_machine

# =========== PHYSICS =========
func _gravity_switch_controls():
	if self._switching_gravity == false:
			self.anim.set_switch_available()
			self._switching_gravity = true
		
	if self.direction.started_slowing_input():
		# slowing, waiting for gravity switch
		_velocity = Vector2.ZERO
		self.anim.set_switched()
		self.velocity.speed_slow(0.05)
	
	if self.direction.released_slowing_input():
		# gravity switch cancelled
		self.velocity.speed_reset()
		
	var new_orient_type = self.direction.switch_input()
	if new_orient_type != self.direction._type:
		# switched gravity
		self.velocity.set_orient_type(new_orient_type)
		self.direction.set_orient_type(new_orient_type)
		self.anim.set_orient_type(new_orient_type)
		self.orient_type = new_orient_type
		emit_signal("energy_consumed")

func _gravity_switch_reset():
	if self._switching_gravity == true:
			self.anim.set_idle()
			self.velocity.speed_reset()
			self._switching_gravity = false

func _is_falling_slow() -> bool:
	return self.velocity.is_falling_with_max_speed(_velocity, is_on_floor(), 200, 600)

func gravity_switch(has_enough_energy: bool):
	# manage special case to switch gravity orientation	
	if _is_falling_slow() and has_enough_energy:
		_gravity_switch_controls()
	else:
		_gravity_switch_reset()
	
	if _is_falling_slow() and self.direction.started_slowing_input() and not has_enough_energy:
		emit_signal("switch_attempt")

func update_animation():
	var is_falling_slow = self.velocity.is_falling_with_max_speed(
		_velocity, is_on_floor(), 200, 600)
	var _direction = self.direction.get_direction(is_on_floor())
	
	# set animation according to the direction
	if not is_falling_slow:
		self.anim.set_moving_animation(
			self.direction.is_moving(_direction),
			self.direction.is_moving_left(_direction),
			self.direction.is_moving_right(_direction)
		)

func update_collision():
	if is_on_floor() and _previous_is_on_floor == false:
		# landed
		var position = get_global_position()
		emit_signal("landed", position, orient_type)
		
	_previous_is_on_floor = is_on_floor()

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group(TILE_KILL_GROUP):
			# dies
			self.sounds.death()
			self.anim.set_death()
			get_parent().set_physics_process(false)

func update_direction_and_velocity(delta):
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
	
	# emit signal
	if self.direction.is_just_jumped(_direction):
		var position = get_global_position()
		emit_signal("jumped", position, orient_type)
		sounds.jump()

func _on_DetectionArea_area_entered(area: Area2D):
	# detected object
	if area.is_in_group(ENERGY_GROUP):
		emit_signal("energy_found", area)
		sounds.energy_gain()

	elif area.is_in_group(MACHINE_GROUP):
		if self._near_machine == false:
			self._near_machine = true
		
func _on_DetectionArea_area_exited(area: Area2D) -> void:
	# left object
	if area.is_in_group(MACHINE_GROUP):
		if self._near_machine == true:
			self._near_machine = false

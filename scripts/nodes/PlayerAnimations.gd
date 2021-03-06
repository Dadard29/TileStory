extends AnimatedSprite

const ORIENT_T = preload("res://scripts/classes/OrientationsType.gd").ORIENT_TYPE

const _ANIMATION_IDLE = "idle"
const _ANIMATION_MOVE_RIGHT = "move_right"
const _ANIMATION_SWITCH_AVAILABLE = "switch_available"
const _ANIMATION_SWITCHED = "switched"
const _ANIMATION_SPAWN = "spawn"
const _ANIMATION_DEATH = "death"

var _moving: bool = false
var _is_inverted: bool = false

func _ready():
	pass

func set_death():
	self.play(_ANIMATION_DEATH)

func set_idle():
	self.play(_ANIMATION_IDLE)

func set_spawn():
	self.set_animation(_ANIMATION_SPAWN)
	self.play(_ANIMATION_SPAWN)
	
func set_switch_available():
	self.play(_ANIMATION_SWITCH_AVAILABLE)

func set_switched():
	self.play(_ANIMATION_SWITCHED)

func _move_left():
	self.play(_ANIMATION_MOVE_RIGHT)
	self.set_flip_h(not self._is_inverted)
	
func _move_right():
	self.play(_ANIMATION_MOVE_RIGHT)
	self.set_flip_h(self._is_inverted)

func set_moving_animation(is_moving: bool, is_moving_left: bool, is_moving_right: bool):
	var _moving_previous = _moving
	_moving = is_moving
	
	if _moving_previous != _moving:
		if _moving:
			if is_moving_left:
				self._move_left()

			elif is_moving_right:
				self._move_right()
				
		else:
			self.set_idle()

func set_orient_type(orient_type):
	if orient_type == ORIENT_T.UP:
		self.set_flip_v(false)
		self.set_rotation_degrees(0)
		self._is_inverted = false
		
	elif orient_type == ORIENT_T.DOWN:
		self.set_flip_v(true)
		self.set_rotation_degrees(0)
		self._is_inverted = false
	
	elif orient_type == ORIENT_T.RIGHT:
		self.set_flip_v(false)
		self.set_rotation_degrees(90)
		self._is_inverted = false
	
	elif orient_type == ORIENT_T.LEFT:
		self.set_flip_v(false)
		self.set_rotation_degrees(270)
		self._is_inverted = true


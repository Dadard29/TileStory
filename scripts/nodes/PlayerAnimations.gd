extends AnimatedSprite

const _ANIMATION_IDLE = "idle"
const _ANIMATION_MOVE_RIGHT = "move_right"

var _moving: bool = false

func _ready():
	pass

func _idle():
	self.play(_ANIMATION_IDLE)

func _move_left():
	self.play(_ANIMATION_MOVE_RIGHT)
	self.set_flip_h(true)
	
func _move_right():
	self.play(_ANIMATION_MOVE_RIGHT)
	self.set_flip_h(false)

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
			self._idle()


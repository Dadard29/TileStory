extends AnimatedSprite

const _ANIMATION_IDLE = "idle"
const _ANIMATION_MOVE_RIGHT = "move_right"

func _ready():
	pass

func idle():
	print("changed anim: idle")
	self.play(_ANIMATION_IDLE)

func move_left():
	print("changed anim: move left")
	self.play(_ANIMATION_MOVE_RIGHT)
	self.set_flip_h(true)
	
func move_right():
	print("changed anim: move right")
	self.play(_ANIMATION_MOVE_RIGHT)
	self.set_flip_h(false)


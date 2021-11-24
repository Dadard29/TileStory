extends Node

onready var _jump_anim = $JumpEvent
onready var _jump_anim_left = $JumpEvent/JumpAnimationLeft
onready var _jump_anim_right = $JumpEvent/JumpAnimationRight

const _ANIMATION_JUMP = "jump"

# Called when the node enters the scene tree for the first time.
func _ready():
	_jump_anim_left.set_animation(_ANIMATION_JUMP)
	_jump_anim_right.set_animation(_ANIMATION_JUMP)

func _on_Player_jumped(position: Vector2):
	_jump_anim.set_position(position)
	_jump_anim_left.set_frame(0)
	_jump_anim_right.set_frame(0)
	
	_jump_anim_left.play()
	_jump_anim_right.play()

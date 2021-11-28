extends Node

onready var _jump_anim = $JumpEvent
onready var _jump_anim_left = $JumpEvent/JumpAnimationLeft
onready var _jump_anim_right = $JumpEvent/JumpAnimationRight

const _ANIMATION_JUMP = "jump"

const ORIENT_T = preload("res://scripts/classes/OrientationsType.gd").ORIENT_TYPE

# Called when the node enters the scene tree for the first time.
func _ready():
	_jump_anim_left.set_animation(_ANIMATION_JUMP)
	_jump_anim_right.set_animation(_ANIMATION_JUMP)

func _on_Player_jumped(position: Vector2, orient_type):
	
	if orient_type == ORIENT_T.UP:
		_jump_anim.set_rotation_degrees(0)
		
	elif orient_type == ORIENT_T.DOWN:
		_jump_anim.set_rotation_degrees(180)
		
	elif orient_type == ORIENT_T.RIGHT:
		_jump_anim.set_rotation_degrees(90)
	
	elif orient_type == ORIENT_T.LEFT:
		_jump_anim.set_rotation_degrees(270)
	
	_jump_anim.set_position(position)
	_jump_anim_left.set_frame(0)
	_jump_anim_right.set_frame(0)
	
	_jump_anim_left.play()
	_jump_anim_right.play()

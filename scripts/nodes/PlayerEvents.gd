extends Node

# child nodes
onready var _jump_anim = $JumpEvent
onready var _jump_anim_left = $JumpEvent/JumpAnimationLeft
onready var _jump_anim_right = $JumpEvent/JumpAnimationRight

onready var _land_event = $LandEvent
onready var _land_event_particles = $LandEvent/Particles2D


const _ANIMATION_JUMP = "jump"

const ORIENT_T = preload("res://scripts/classes/OrientationsType.gd").ORIENT_TYPE

# Called when the node enters the scene tree for the first time.
func _ready():
	_jump_anim_left.set_animation(_ANIMATION_JUMP)
	_jump_anim_right.set_animation(_ANIMATION_JUMP)


func get_rotation_degree_from_orient_type(orient_type) -> int:
	var _rotation: int
	if orient_type == ORIENT_T.UP:
		_rotation = 0
		
	elif orient_type == ORIENT_T.DOWN:
		_rotation = 180
		
	elif orient_type == ORIENT_T.RIGHT:
		_rotation = 90
	
	elif orient_type == ORIENT_T.LEFT:
		_rotation = 270
	
	return _rotation

func _on_Player_jumped(position: Vector2, orient_type):
	var _rotation = get_rotation_degree_from_orient_type(orient_type)
	
	_jump_anim.set_rotation_degrees(_rotation)
	_jump_anim.set_position(position)
	_jump_anim_left.set_frame(0)
	_jump_anim_right.set_frame(0)
	
	_jump_anim_left.play()
	_jump_anim_right.play()


func _on_Player_landed(position: Vector2, orient_type) -> void:
	var _rotation = get_rotation_degree_from_orient_type(orient_type)
	
	_land_event.set_rotation_degrees(_rotation)
	_land_event.set_position(position)
	_land_event_particles.set_emitting(true)

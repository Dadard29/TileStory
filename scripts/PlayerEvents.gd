extends Node

onready var jump_anim = $JumpAnimation
onready var jump_anim_left = $JumpAnimation/JumpAnimationLeft
onready var jump_anim_right = $JumpAnimation/JumpAnimationRight

const ANIMATION_JUMP = "jump"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	jump_anim_left.set_animation(ANIMATION_JUMP)
	jump_anim_right.set_animation(ANIMATION_JUMP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func jump(position: Vector2):
	print(position)
	jump_anim.set_position(position)
	jump_anim_left.set_frame(0)
	jump_anim_right.set_frame(0)
	
	jump_anim_left.play()
	jump_anim_right.play()

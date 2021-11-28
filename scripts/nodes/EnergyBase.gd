extends Node2D

onready var animations = $Animations
onready var tween = $Tween

const ANIMATION_IDLE = "idle"
var rng = RandomNumberGenerator.new()

export(int) var MIN_ANIMATION_SPEED = 12
export(int) var MAX_ANIMATION_SPEED = 12
export(int) var TWEEN_DURATION = 5
var _tween_values: Array

func _ready():
	rng.randomize()
	var max_frame_idx = animations.frames.get_frame_count(ANIMATION_IDLE)
	var start_frame = rng.randf_range(0, max_frame_idx)
	animations.set_frame(start_frame)
	animations.play(ANIMATION_IDLE)
	
	var start_rotation_degree = rng.randf_range(0, 180)
	_tween_values = [start_rotation_degree, start_rotation_degree + 180]
	_start_tween_rotation()
	

func _start_tween_rotation():
	tween.interpolate_property(animations, "rotation_degrees",
		_tween_values[0], _tween_values[1], TWEEN_DURATION,
		tween.TRANS_LINEAR, tween.EASE_IN_OUT)
	tween.start()
	

func _on_Tween_tween_all_completed() -> void:
	_tween_values.invert()
	_start_tween_rotation()

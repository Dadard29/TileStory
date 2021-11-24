extends Node2D

onready var animations = $Animations

const ANIMATION_IDLE = "idle"
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var idle_fps = rng.randf_range(0.0, 6.0)
	animations.frames.set_animation_speed(ANIMATION_IDLE, idle_fps)
	animations.play(ANIMATION_IDLE)
	

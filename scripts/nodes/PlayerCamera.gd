extends Camera2D

onready var tween = $Tween

export(int) var ZOOM_DURATION = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func loading_zoom():
	var initial = Vector2(1, 1)
	var final = Vector2(0.5, 0.5)
	tween.interpolate_method(self, "set_zoom", initial, final,
	ZOOM_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

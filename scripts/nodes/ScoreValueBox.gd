extends HBoxContainer


onready var tween = $ScoreTween
onready var score = $ScoreValue

export(int) var SCORE_TWEEN_DURATION = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _update_score_value(value: int):
	score.set_text(String(value))

func set_score_value(new_value: int):
	if tween.is_active():
		tween.stop_all()
		_update_score_value(new_value)
	else:
		var old_value = int(score.get_text())
		print(old_value)
		tween.interpolate_method(self, "_update_score_value", old_value, new_value,
			SCORE_TWEEN_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
	
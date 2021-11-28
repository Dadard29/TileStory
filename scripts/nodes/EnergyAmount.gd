extends TextureProgress

onready var tween = $Tween
onready var flicker_timer = $FlickerTimer

export(int) var valid_amount = 5
export(Color) var valid_color = Color("0aa4e9")
export(Color) var invalid_color = Color("ee3a2a")

var neutral_color = Color.white

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func set_energy_amount(old_energy_amount: int, new_energy_amount: int):
	var duration = 1.0
	tween.interpolate_property(self, "value",
		old_energy_amount, new_energy_amount,
		duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	if new_energy_amount >= valid_amount:
		set_tint_progress(valid_color)
	
	if new_energy_amount <= valid_amount:
		set_tint_progress(invalid_color)

func flicker_texture_under():
	self.set_tint_over(invalid_color)
	flicker_timer.start()


func _on_FlickerTimer_timeout() -> void:
	self.set_tint_over(neutral_color)

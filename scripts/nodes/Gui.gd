extends CanvasLayer


onready var energy_amount = $Base/EnergyAmount

onready var space_key = $Base/KeysMargin/KeysContainer/Space
onready var switch_key = $Base/KeysMargin/KeysContainer/Switch
onready var interact_key = $Base/KeysMargin/KeysContainer/Interact

func _ready():
	pass # Replace with function body.


func update_energy_amount(old_energy_amount: int, new_energy_amount: int):
	energy_amount.set_energy_amount(old_energy_amount, new_energy_amount)
	

func flicker_progress_bar():
	energy_amount.flicker_texture_under()
	

func set_space_key_visible(is_visible: bool):
	if space_key.is_visible() != is_visible:
		space_key.set_visible(is_visible)

func set_switch_key_visible(is_visible: bool):
	if switch_key.is_visible() != is_visible:
		switch_key.set_visible(is_visible)

func set_interact_visible(is_visible: bool):
	if interact_key.is_visible() != is_visible:
		interact_key.set_visible(is_visible)

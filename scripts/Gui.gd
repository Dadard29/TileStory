extends CanvasLayer


onready var energy_amount = $Base/EneryAmount

func _ready():
	pass # Replace with function body.


func set_energy_amount(new_energy_amount: int):
	energy_amount.set_value(new_energy_amount)

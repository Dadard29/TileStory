extends Node2D

onready var GUI = $Gui

const ENERGY_SMALL_GROUP = "energy_small"
const ENERGY_MEDIUM_GROUP = "energy_medium"

var _energy: int = 0

signal jumped

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Kinematic_jumped(position: Vector2):
	emit_signal("jumped", position)


func _on_Kinematic_energy_changed(area: Area2D) -> void:
	if area.is_in_group(ENERGY_SMALL_GROUP):
		_energy += 1
	elif area.is_in_group(ENERGY_MEDIUM_GROUP):
		_energy += 5
		
	area.destroy()
	GUI.set_energy_amount(_energy)

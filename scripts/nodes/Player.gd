extends Node2D

# child nodes
onready var GUI = $Gui
onready var Kinematic = $Kinematic

# constants
const ENERGY_SMALL_GROUP = "energy_small"
const ENERGY_MEDIUM_GROUP = "energy_medium"
const ENERGY_SMALL_AMOUNT = 1
const ENERGY_MEDIUM_AMOUNT = 5
const ENERGY_SWITCH_COST = 5

# locals
var _energy: int = 0

# globals
# FIXME: DEBUG ONLY
export(bool) var energy_infinite_debug = false

# signals
signal jumped

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Kinematic_jumped(position: Vector2, orient_type):
	emit_signal("jumped", position, orient_type)


func _on_Kinematic_energy_found(area: Area2D) -> void:
	if area.is_in_group(ENERGY_SMALL_GROUP):
		_energy += ENERGY_SMALL_AMOUNT
	elif area.is_in_group(ENERGY_MEDIUM_GROUP):
		_energy += ENERGY_MEDIUM_AMOUNT
		
	area.destroy()
	GUI.set_energy_amount(_energy)

func _on_Kinematic_energy_consumed() -> void:
	if energy_infinite_debug:
		return

	_energy -= ENERGY_SWITCH_COST
	GUI.set_energy_amount(_energy)

func has_enough_energy_to_switch() -> bool:
	if energy_infinite_debug:
		return true
	
	return self._energy >= ENERGY_SWITCH_COST

func _physics_process(delta: float) -> void:
	var has_enough_energy = self.has_enough_energy_to_switch()
	Kinematic.gravity_switch(has_enough_energy)
	
	Kinematic.update_direction_and_velocity(delta)
	Kinematic.update_animation()

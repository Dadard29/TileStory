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
const LOADING_KEY = "interact"

# locals
var _energy: int = 0
var _activated: bool = false

# globals
# FIXME: DEBUG ONLY
export(bool) var energy_infinite_debug = false

# signals
signal jumped
signal landed
signal loading
signal death

func _ready():
	pass
	
func _on_Kinematic_spawned() -> void:
	_activated = true

func _on_Kinematic_jumped(position: Vector2, orient_type):
	emit_signal("jumped", position, orient_type)

func _on_Kinematic_landed(position: Vector2, orient_type) -> void:
	emit_signal("landed", position, orient_type)


func _on_Kinematic_energy_found(area: Area2D) -> void:
	var previous_energy = _energy
	if area.is_in_group(ENERGY_SMALL_GROUP):
		_energy += ENERGY_SMALL_AMOUNT
	elif area.is_in_group(ENERGY_MEDIUM_GROUP):
		_energy += ENERGY_MEDIUM_AMOUNT
		
	area.destroy()
	GUI.update_energy_amount(previous_energy, _energy)

func _on_Kinematic_energy_consumed() -> void:
	if energy_infinite_debug:
		return
	
	var previous_energy = _energy

	_energy -= ENERGY_SWITCH_COST
	GUI.update_energy_amount(previous_energy, _energy)

func _on_Kinematic_switch_attempt() -> void:
	GUI.flicker_progress_bar()


func _on_Kinematic_death() -> void:
	_activated = false
	emit_signal("death")

func has_enough_energy_to_switch() -> bool:
	if energy_infinite_debug:
		return true
	
	return self._energy >= ENERGY_SWITCH_COST

func update_gui():
	var has_enough_energy = self.has_enough_energy_to_switch()
	var is_slow_available = Kinematic.is_slow_available(has_enough_energy)
	GUI.set_space_key_visible(is_slow_available)
	
	var is_switch_available = Kinematic.is_switch_available(has_enough_energy)
	GUI.set_switch_key_visible(is_switch_available)
	
	var is_near_machine = Kinematic.is_near_machine()
	GUI.set_interact_visible(is_near_machine)

func update_world():
	var is_near_machine = Kinematic.is_near_machine()
	var is_loading_key_pressed = Input.is_action_just_pressed("interact")
	if is_near_machine and is_loading_key_pressed:
		emit_signal("loading")

func _physics_process(delta: float) -> void:
	if not _activated:
		return
	
	var has_enough_energy = self.has_enough_energy_to_switch()
	Kinematic.gravity_switch(has_enough_energy)
	
	Kinematic.update_direction_and_velocity(delta)
	Kinematic.update_animation()
	Kinematic.update_collision()
	
	update_gui()
	update_world()

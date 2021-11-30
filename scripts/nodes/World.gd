extends Node2D

onready var machine = $Machine

export(Vector2) var position_override = Vector2()

signal win

func machine_load():
	machine.play_loading()

func _on_Machine_win() -> void:
	emit_signal("win")

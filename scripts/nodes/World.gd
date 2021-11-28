extends Node2D

onready var machine = $Machine

export(Vector2) var position_override = Vector2()

func machine_load():
	machine.play_loading()


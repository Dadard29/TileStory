extends Node2D

onready var GUI = $GUI

signal jumped

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_PlayerControl_jumped(position: Vector2):
	emit_signal("jumped", position)

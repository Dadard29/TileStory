extends Node2D

onready var main = $Main
onready var menu = $Control

func _ready() -> void:
	pass

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _on_Control_level(level_path) -> void:
	menu.hide()
	main.set_level(level_path)

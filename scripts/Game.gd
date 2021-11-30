extends Node2D

onready var main = $Main
onready var menu = $Control

var _score: int = 0

func _ready() -> void:
	pass

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _on_Control_level(level_path) -> void:
	menu.hide()
	main.set_level(level_path)


func _on_Main_win(energy_used: int) -> void:
	_score += energy_used
	menu.set_score(_score)
	menu.show()


func _on_Main_menu_toggle() -> void:
	menu.toggle()

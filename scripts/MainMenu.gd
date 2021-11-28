extends CanvasLayer

onready var full_rect = $FullRect

signal level(level_path)

const LEVEL_BASE = "res://scenes/levels/"
const LEVEL_0 = "Level0.tscn"
const LEVEL_1 = "Level1.tscn"

func _ready() -> void:
	pass # Replace with function body.

func hide():
	full_rect.set_visible(false)

func show():
	full_rect.set_visible(true)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
	

func _emit_level_signal(level_name):
	emit_signal("level", LEVEL_BASE + level_name)

func _on_Level0_pressed() -> void:
	_emit_level_signal(LEVEL_0)

func _on_Level1_pressed() -> void:
	_emit_level_signal(LEVEL_1)

extends MarginContainer

onready var button = $Button

var _level_path: String = ""
var _level_name: String = ""

signal level_selected(level_path)

func _ready() -> void:
	button.set_text(_level_name)
	
func set_level_path(level_path: String, level_name: String):
	_level_path = level_path
	_level_name = level_name

func _on_Button_pressed() -> void:
	emit_signal("level_selected", _level_path)

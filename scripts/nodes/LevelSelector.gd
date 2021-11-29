extends MarginContainer

onready var button = $Button

var _level_path: String = ""
var _level_name: String = ""
var _icon: Texture

signal level_selected(level_path)

func _ready() -> void:
	button.set_text(_level_name)
	button.set_button_icon(_icon)
	
func set_level_path(level_path: String, level_name: String, icon: Texture):
	_level_path = level_path
	_level_name = level_name
	_icon = icon

func _on_Button_pressed() -> void:
	emit_signal("level_selected", _level_path)

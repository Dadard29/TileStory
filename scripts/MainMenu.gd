extends CanvasLayer

onready var full_rect = $FullRect
onready var level_box = $FullRect/CenterContainer/VB/LevelSelection/VBoxContainer/LevelBox

signal level(level_path)

const LEVEL_BASE = "res://scenes/levels/"

var level_selector = preload("res://scenes/LevelSelector.tscn")
var levels_data: Array = [
	{
		"icon": preload("res://images/icons/player_icon.png"),
		"name": "Awake"
	},
	{
		"icon": preload("res://images/icons/energy_small_icon.png"),
		"name": "Power up"
	},
	{
		"icon": preload("res://images/icons/spike_icon.png"),
		"name": "Beware"
	}
]

func _list_levels():
	var files: Array = []
	var dir = Directory.new()
	dir.open(LEVEL_BASE)
	dir.list_dir_begin()
	
	# list the frames in the directory
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.ends_with(".import") and not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()
	
	# set the frames order using the file name
	files.sort()
	return files

func _ready() -> void:
	var level_files = _list_levels()
	
	var i = 0
	for level_file in level_files:
		var new_level_selector = level_selector.instance()
		
		var level_path = LEVEL_BASE + level_file
		var level_name = levels_data[i]["name"]
		var icon = levels_data[i]["icon"]
		
		new_level_selector.set_level_path(level_path, level_name, icon)
		level_box.add_child(new_level_selector)
		
		new_level_selector.connect("level_selected", self, "_emit_level_signal")
		
		i += 1

func hide():
	full_rect.set_visible(false)

func show():
	full_rect.set_visible(true)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _emit_level_signal(level_path):
	emit_signal("level", level_path)

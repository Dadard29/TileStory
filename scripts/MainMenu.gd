extends CanvasLayer

onready var full_rect = $FullRect
onready var level_box = $FullRect/Panel/Center/VB/LevelSelection/LevelPanel/LevelVBox/LevelBox
onready var score = $FullRect/Panel/Center/VB/Score/ScorePanel/ScoreBox/ScoreValueBox


signal level(level_path)

const LEVEL_BASE = "res://scenes/levels/"


var level_selector = preload("res://scenes/LevelSelector.tscn")
export(Array) var levels_names: Array = [
	"Awake", "Power Up", "Beware", "Optional", "Bounce it", "Slow motion"
]
var level_default_icon = preload("res://images/icons/player_icon.png")

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
		
		var level_name: String
		if i >= len(levels_names):
			level_name = "Level " + String(i)
		else:
			level_name = levels_names[i]
		
		new_level_selector.set_level_path(level_path, level_name)
		level_box.add_child(new_level_selector)
		
		new_level_selector.connect("level_selected", self, "_emit_level_signal")
		
		i += 1

func hide():
	full_rect.set_visible(false)

func show():
	full_rect.set_visible(true)

func toggle():
	full_rect.set_visible(not full_rect.is_visible())

func set_score(new_score: int):
	score.set_score_value(new_score)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _emit_level_signal(level_path):
	emit_signal("level", level_path)

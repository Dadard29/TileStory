extends Node2D

onready var player_events = $PlayerEvents
onready var music = $Music

var player_scene = preload("res://scenes/Player.tscn")

var _level: Node2D = null
var _player: Node2D = null

const LEVEL_NODE_NAME = "World"
const PLAYER_NODE_NAME = "Player"

const MUTE_KEY = "mute"
const RESTART_KEY = "restart"

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# global inputs
	if Input.is_action_just_pressed(MUTE_KEY):
		music.toggle_music_mute()
	
	if Input.is_action_just_pressed(RESTART_KEY):
		# dont restart if no level loaded
		if _level != null:
			restart_level()


func clean_player():
	if _player != null:
		remove_child(_player)

func spawn_player():
	_player = player_scene.instance()
	add_child(_player)
	
	var _err
	
	_err = _player.connect("jumped", player_events, "_on_Player_jumped")
	_err = _player.connect("landed", player_events, "_on_Player_landed")
	_err = _player.connect("loading", self, "_on_Player_loading")
	_err = _player.connect("death", self, "_on_Player_death")
	
	_player.spawn()

func clean_level():
	if _level != null:
		remove_child(_level)

func set_level(level_path: String):
	clean_level()
	clean_player()

	_level = load(level_path).instance()
	add_child(_level)
	move_child(_level, 0)
	
	spawn_player()
	set_process(true)

func restart_level():
	clean_player()
	spawn_player()

# players ask to load the machine
func _on_Player_loading() -> void:
	music.stop()
	_level.machine_load()
	set_process(false)

func _on_Player_death() -> void:
	restart_level()

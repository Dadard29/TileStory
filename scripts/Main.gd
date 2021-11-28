extends Node2D

# manage level loading

const LEVEL_NODE_NAME = "World"

func _ready() -> void:
	set_level("res://scenes/levels/Level1.tscn")

func set_level(level_path: String):
	for child in get_children():
		if child.name == LEVEL_NODE_NAME:
			remove_child(child)
			
	var level_scene = load(level_path).instance()
	add_child(level_scene)
	move_child(level_scene, 0)

func _on_Player_loading() -> void:
	get_child(0).machine_load()

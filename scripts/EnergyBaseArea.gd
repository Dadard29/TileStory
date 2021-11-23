extends Area2D

func _ready() -> void:
	pass # Replace with function body.


func destroy():
	get_parent().queue_free()

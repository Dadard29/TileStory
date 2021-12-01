extends Line2D

export(int) var MAX_LENGTH = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func update_points(new_position: Vector2):
	add_point(new_position)
	while get_point_count() > MAX_LENGTH:
		remove_point(0)

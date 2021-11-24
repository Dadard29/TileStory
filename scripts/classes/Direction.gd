class DIRECTION_CLASS:
	var _type: int
	
	const _ui_up = "ui_up"
	const _ui_left = "ui_left"
	const _ui_right = "ui_right"
	const _ui_down = "ui_down"
	
	var _jump_key: String
	var _left_side_key: String
	var _right_side_key: String
	
	var ORIENT_T = preload("res://scripts/classes/OrientationsType.gd").ORIENT_TYPE
	
	func _init(type):
		self._update_orient_type(type)
	
	func _update_orient_type(type):
		self._type = type
		if self._type == ORIENT_T.UP:
			self._jump_key = _ui_up
			self._left_side_key = _ui_left
			self._right_side_key = _ui_right
			
		elif self._type == ORIENT_T.DOWN:
			self._jump_key = _ui_down
			self._left_side_key = _ui_left
			self._right_side_key = _ui_right
			
		elif self._type == ORIENT_T.RIGHT:
			self._jump_key = _ui_right
			self._left_side_key = _ui_up
			self._right_side_key = _ui_down
			
		elif self._type == ORIENT_T.LEFT:
			self._jump_key = _ui_left
			self._left_side_key = _ui_up
			self._right_side_key = _ui_down 
			
	func _is_up_or_down() -> bool:
		return [ORIENT_T.UP, ORIENT_T.DOWN].has(self._type)
	
	func _is_right_or_left() -> bool:
		return [ORIENT_T.RIGHT, ORIENT_T.LEFT].has(self._type)
	
	func get_direction(is_on_floor: bool) -> Vector2:
		var direction_y = -1 if is_on_floor and Input.is_action_pressed(self._jump_key) else 1
		var direction_x = Input.get_action_strength(
				self._right_side_key
			) - Input.get_action_strength(
				self._left_side_key
			)
		
		if self._is_up_or_down():
			return Vector2(direction_x, direction_y)

		elif self._is_right_or_left():
			direction_y *= -1
			return Vector2(direction_y, direction_x)
		
		return Vector2.ZERO

	func is_just_jumped(direction: Vector2) -> bool:
		var is_jumping_b: bool
		if self._is_up_or_down():
			is_jumping_b = direction.y < 0
		
		elif self._is_right_or_left():
			is_jumping_b = direction.x > 0
		
		return is_jumping_b

	func is_jump_interrupted(is_jumping: bool) -> bool:
		var is_jump_key_just_released = Input.is_action_just_released(self._jump_key)
		return is_jump_key_just_released and is_jumping
	
	func is_moving_left(direction: Vector2) -> bool:
		var is_moving_left_b: bool
		if self._is_up_or_down():
			is_moving_left_b = direction.x < 0
		
		elif self._is_right_or_left():
			is_moving_left_b = direction.y < 0
		
		return is_moving_left_b
	
	func is_moving_right(direction: Vector2) -> bool:
		var is_moving_right_b: bool
		if self._is_up_or_down():
			is_moving_right_b = direction.x > 0
			
		elif self._is_right_or_left():
			is_moving_right_b = direction.y > 0
		
		return is_moving_right_b
	
	func is_moving(direction: Vector2) -> bool:
		var is_moving_side_b: bool
		if self._is_up_or_down():
			is_moving_side_b = direction.x != 0
			
		elif self._is_right_or_left():
			is_moving_side_b = direction.y != 0
		
		return is_moving_side_b

enum ORIENT_TYPE{
	UP,
	DOWN,
	RIGHT,
	LEFT
}

class Orient:
	var orient_type: int
	var speed_side: int
	var speed_jump: int
	var gravity: int
	var floor_normal: Vector2
	
	func _init(orient_type, speed_side, speed_jump, gravity):
		self.orient_type = orient_type
		self.speed_side = speed_side
		self.speed_jump = speed_jump
		self.gravity = gravity
		
		if self.orient_type == ORIENT_TYPE.UP:
			self.floor_normal = Vector2.UP
			
		elif self.orient_type == ORIENT_TYPE.DOWN:
			self.floor_normal = Vector2.DOWN
			
		elif self.orient_type == ORIENT_TYPE.RIGHT:
			self.floor_normal = Vector2.RIGHT
			
		elif self.orient_type == ORIENT_TYPE.LEFT:
			self.floor_normal = Vector2.LEFT
	
	func _is_up_or_down() -> bool:
		return [ORIENT_TYPE.UP, ORIENT_TYPE.DOWN].has(self.orient_type)
	
	func _is_right_or_left() -> bool:
		return [ORIENT_TYPE.RIGHT, ORIENT_TYPE.LEFT].has(self.orient_type)

	func get_velocity(velocity: Vector2, direction: Vector2, delta, is_on_floor: bool):
		var direction_side: float
		var direction_jump: float

		if self._is_up_or_down():
			direction_side = direction.x
			direction_jump = direction.y

		elif self._is_right_or_left():
			direction_side = direction.y
			direction_jump = direction.x
		
		var velocity_side = self.speed_side * direction_side
		var velocity_jump: float
		if direction_jump != 0:
			if is_on_floor:
				# jumping
				velocity_jump = self.speed_jump * direction_jump
			else:
				# falling
				velocity_jump = self.gravity * delta
		
		var out: Vector2
		if self.orient_type == ORIENT_TYPE.UP:
			out = Vector2(velocity_side, velocity_jump)
			
		elif self.orient_type == ORIENT_TYPE.DOWN:
			out = Vector2(velocity_side, -velocity_jump)
		
		elif self.orient_type == ORIENT_TYPE.RIGHT:
			out = Vector2(velocity_jump, velocity_side)
		
		elif self.orient_type == ORIENT_TYPE.LEFT:
			out = Vector2(-velocity_jump, velocity_side)
		
		return out

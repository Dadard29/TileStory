class VELOCITY_CLASS:
	var _type: int
	
	var _speed_side: float
	var _speed_side_default: float
	var _speed_jump: float
	var _speed_jump_default: float
	var _gravity: float
	var _gravity_default: float
	
	var _floor_normal: Vector2
	
	var ORIENT_T = preload("res://scripts/classes/OrientationsType.gd").ORIENT_TYPE
	const JUMP_INTERRUPTION_SLOW = 0.6
	
	func _init(type, speed_side, speed_jump, gravity):
		self.set_orient_type(type)
		
		self._speed_side_default = speed_side
		self._speed_jump_default = speed_jump
		self._gravity_default = gravity
		self.speed_reset()
	
	func get_floor_normal() -> Vector2:
		return self._floor_normal
	
	func speed_slow(fact: float):
		self._speed_side *= fact
		self._speed_jump *= fact
		self._gravity *= fact
	
	func speed_reset():
		self._speed_side = self._speed_side_default
		self._speed_jump = self._speed_jump_default
		self._gravity = self._gravity_default
	
	func set_orient_type(type):
		self._type = type
		if self._type == ORIENT_T.UP:
			self._floor_normal = Vector2.UP
			
		elif self._type == ORIENT_T.DOWN:
			self._floor_normal = Vector2.DOWN
			
		elif self._type == ORIENT_T.RIGHT:
			self._floor_normal = Vector2.RIGHT
			
		elif self._type == ORIENT_T.LEFT:
			self._floor_normal = Vector2.LEFT
	
	func _is_up_or_down() -> bool:
		return [ORIENT_T.UP, ORIENT_T.DOWN].has(self._type)
	
	func _is_right_or_left() -> bool:
		return [ORIENT_T.RIGHT, ORIENT_T.LEFT].has(self._type)
	
	func _compute_velocity_side(direction_side: float) -> float:
		return self._speed_side * direction_side
	
	func _compute_velocity_jump(
		velocity_jump: float,
		direction_jump: float,
		direction_floor: int,
		jump_factor: int,
		is_on_floor: bool,
		delta: float
	) -> float:

		if direction_jump != 0:
			if is_on_floor:
				# jumping
				velocity_jump = self._speed_jump * direction_jump * direction_floor * jump_factor
			else:
				# falling
				velocity_jump += -self._gravity * delta * direction_floor
		
		return velocity_jump
	
	func _get_velocity_up_or_down(velocity: Vector2, direction: Vector2, delta, is_on_floor: bool) -> Vector2:
		var direction_side = direction.x
		var direction_jump = direction.y
		var velocity_jump = velocity.y
		var direction_floor = self._floor_normal.y
		var jump_factor = -1
		
		var velocity_side = self._compute_velocity_side(direction_side)
		velocity_jump = self._compute_velocity_jump(
			velocity_jump,
			direction_jump,
			direction_floor,
			jump_factor,
			is_on_floor,
			delta
		)
		
		return Vector2(velocity_side, velocity_jump)
	
	func _get_velocity_right_or_left(velocity: Vector2, direction: Vector2, delta, is_on_floor: bool):
		var direction_side = direction.y
		var direction_jump = direction.x
		var velocity_jump = velocity.x
		var direction_floor = self._floor_normal.x
		var jump_factor = 1
		
		var velocity_side = self._compute_velocity_side(direction_side)
		velocity_jump = self._compute_velocity_jump(
			velocity_jump,
			direction_jump,
			direction_floor,
			jump_factor,
			is_on_floor,
			delta
		)
		
		return Vector2(velocity_jump, velocity_side)

	func get_velocity(velocity: Vector2, direction: Vector2, delta, is_on_floor: bool):

		if self._is_up_or_down():
			return self._get_velocity_up_or_down(velocity, direction, delta, is_on_floor)
			
		elif self._is_right_or_left():
			return self._get_velocity_right_or_left(velocity, direction, delta, is_on_floor)
	
	func is_jumping(velocity: Vector2) -> bool:
		var is_jumping_b: bool
		if self._type == ORIENT_T.UP:
			is_jumping_b = velocity.y < 0
		
		elif self._type == ORIENT_T.DOWN:
			is_jumping_b = velocity.y > 0
		
		elif self._type == ORIENT_T.RIGHT:
			is_jumping_b = velocity.x > 0
		
		elif self._type == ORIENT_T.LEFT:
			is_jumping_b = velocity.x < 0
		
		return is_jumping_b
	
	func is_falling_with_max_speed(velocity: Vector2, is_on_floor: bool, min_speed: float, max_speed: float) -> bool:
		var is_falling_b: bool
		if self._type == ORIENT_T.UP:
			is_falling_b = velocity.y > -min_speed and velocity.y < max_speed
		
		elif self._type == ORIENT_T.DOWN:
			is_falling_b = velocity.y < min_speed and velocity.y > -max_speed
		
		elif self._type == ORIENT_T.RIGHT:
			is_falling_b = velocity.x < min_speed and velocity.x > -max_speed
		
		elif self._type == ORIENT_T.LEFT:
			is_falling_b = velocity.x > -min_speed and velocity.x < max_speed
		
		var not_on_floor = not is_on_floor
		return is_falling_b and not_on_floor
	
	func apply_jump_interruption(l_velocity: Vector2) -> Vector2:
		var velocity = l_velocity
		if self._is_up_or_down():
			velocity.y *= JUMP_INTERRUPTION_SLOW

		elif self._is_right_or_left():
			velocity.x *= JUMP_INTERRUPTION_SLOW
			
		return velocity
	
	func is_in_the_air_almost_stopped(velocity: Vector2, step: int, is_on_floor: bool) -> bool:
		var vel: float
		var not_on_floor = not is_on_floor
		
		if self._is_up_or_down():
			vel = velocity.y
			
		elif self._is_right_or_left():
			vel = velocity.x
		
		return vel > -step and vel < step and not_on_floor

extends Node2D

@export var target_node : Node2D
@export var stone_scene : PackedScene

@export var stone_spawn_interval : float = 1.0 
@export var throwing_y_offset: float = -50 
@export var arc_height : float = 150.0 
@export var avoid_range : float = 100.0 
@export var screen_edge_offset : float = 50.0 

var last_spawn_time : float = 0.0

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():

	if not target_node:
		printerr("StoneThrower Error: Target Node not set!")
		set_process(false)
		return
	if not stone_scene:
		printerr("StoneThrower Error: Stone Scene not set!")
		set_process(false)
		return

	var gravity_vector : Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
	gravity = gravity * gravity_vector.y 
	if gravity <= 0:
		printerr("StoneThrower Warning: Gravity is not positive downwards. Using default 980.")
		gravity = 980.0 

	last_spawn_time = stone_spawn_interval 
	set_process(true)

func _process(delta):
	last_spawn_time += delta
	if last_spawn_time >= stone_spawn_interval:
		spawn_stone()
		last_spawn_time = 0.0

func spawn_stone():

	if not is_instance_valid(target_node):
		printerr("StoneThrower: Target node is no longer valid.")
		set_process(false) 
		return

	var target_position = target_node.global_position
	target_position.y += throwing_y_offset 

	var view_rect = get_viewport().get_visible_rect()

	var start_position : Vector2

	if randf() > 0.5:

		var random_x = randf_range(view_rect.position.x, view_rect.end.x)

		while abs(random_x - target_position.x) < avoid_range:
			random_x = randf_range(view_rect.position.x, view_rect.end.x)

		start_position = Vector2(random_x, view_rect.position.y - screen_edge_offset)

	else:

		var random_y = randf_range(view_rect.position.y, view_rect.end.y)

		if randf() > 0.5:

			start_position = Vector2(view_rect.position.x - screen_edge_offset, random_y)
		else:

			start_position = Vector2(view_rect.end.x + screen_edge_offset, random_y)

	if start_position.distance_squared_to(target_position) < 1.0:
		printerr("StoneThrower: Start and target positions are too close. Skipping spawn.")
		return

	var velocity = calculate_arc_velocity(start_position, target_position, arc_height)

	var stone_instance = stone_scene.instantiate()

	if get_parent():
		get_parent().add_child(stone_instance)
	else:

		get_tree().root.add_child(stone_instance)
		printerr("StoneThrower added stone to root. Consider adding spawner to the main scene.")

	stone_instance.global_position = start_position

	if stone_instance.has_method("set_velocity"):
		stone_instance.call("set_velocity", velocity)
	elif "velocity" in stone_instance: 
		stone_instance.set("velocity", velocity)
	else:
		printerr("Stone instance lacks 'velocity' property or 'set_velocity' method.")

	if stone_instance.has_method("set_angular_velocity"):
		stone_instance.call("set_angular_velocity", randf_range(-5.0, 5.0))
	elif "angular_velocity" in stone_instance:
		stone_instance.set("angular_velocity", randf_range(-5.0, 5.0))
	else:
		printerr("Stone instance lacks 'angular_velocity' property or 'set_angular_velocity' method.")

func calculate_arc_velocity(start_pos: Vector2, target_pos: Vector2, p_arc_height: float) -> Vector2:
	var displacement = target_pos - start_pos
	var velocity = Vector2.ZERO

	var g = abs(gravity)
	if g < 0.01: 
		printerr("Gravity is near zero, cannot calculate arc.")
		return Vector2.ZERO 

	var peak_y = min(start_pos.y, target_pos.y) - p_arc_height

	var dy_to_peak = start_pos.y - peak_y
	if dy_to_peak < 0: 

		peak_y = start_pos.y - max(1.0, p_arc_height) 
		dy_to_peak = start_pos.y - peak_y

	velocity.y = -sqrt(max(0.0, 2.0 * g * dy_to_peak)) 

	var time_to_peak : float = 0.0
	if g > 0.01:
		time_to_peak = -velocity.y / g

	var dy_fall = target_pos.y - peak_y
	var time_to_fall : float = 0.0
	if dy_fall > 0 and g > 0.01: 
		time_to_fall = sqrt(2.0 * dy_fall / g)
	elif dy_fall <= 0:

		pass 

	var total_time = time_to_peak + time_to_fall

	if total_time > 0.001: 
		velocity.x = displacement.x / total_time
	else:

		velocity.x = 0
		if start_pos.distance_squared_to(target_pos) < 1.0 :

			velocity = Vector2.DOWN * 100 

	return velocity

extends Node2D

@export var target_node : Node2D
@export var stone_scene : PackedScene  

@export var stone_spawn_interval : float = 11.0  
var last_spawn_time : float = 5.0  
var gravity : float = 850.0
var arc_height : float = 200.0
var avoid_range : float = 220.0 
@export var throwing_y_offset: float = -200
#var debug_path : Array = []  

func _ready():
	set_process(true)

func _process(delta):
	last_spawn_time += delta
	if last_spawn_time >= stone_spawn_interval:
		spawn_stone()
		last_spawn_time = 0.0

func spawn_stone():
	var target_position = target_node.global_position
	target_position.y += throwing_y_offset
	var start_position : Vector2
	
	if randf() > 0.99:  # Horizontal or vertical spawn?
		var random_x = randf_range(target_position.x - 1600, target_position.x + 1600)
		while abs(random_x - target_position.x) < avoid_range:
			random_x = randf_range(target_position.x - 1600, target_position.x + 1600)
		start_position = Vector2(random_x, target_position.y - 700)  # Spawn above
	else:
		var random_y = randf_range(target_position.y - 1100, target_position.y + 400)
		if randf() > 0.9:
			start_position = Vector2(target_position.x - 1600, random_y)  # Left side
		else:
			start_position = Vector2(target_position.x + 1600, random_y)  # Right side

	var velocity = calculate_arc_velocity(start_position, target_position, arc_height)

	var stone_instance = stone_scene.instantiate()  
	add_child(stone_instance)

	stone_instance.global_position = start_position
	stone_instance.set("linear_velocity", velocity)
	stone_instance.set("angular_velocity", randf_range(-5.0, 5.0))


func calculate_arc_velocity(start_pos: Vector2, target_pos: Vector2, arc_height: float) -> Vector2:
	var displacement = target_pos - start_pos
	var velocity = Vector2.ZERO

	var highest_point = min(start_pos.y, target_pos.y) - arc_height
	var dy_to_peak = start_pos.y - highest_point
	var time_to_peak = sqrt(2.0 * dy_to_peak / gravity)
	var dy_fall = target_pos.y - highest_point
	var time_to_fall = sqrt(2.0 * dy_fall / gravity)
	var total_time = time_to_peak + time_to_fall

	velocity.x = displacement.x / total_time
	velocity.y = -sqrt(2.0 * gravity * dy_to_peak)

	return velocity

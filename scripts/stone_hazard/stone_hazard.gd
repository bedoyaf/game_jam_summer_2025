extends Node2D

@export var target_node : Node2D
@export var stone_scene : PackedScene  

var stone_spawn_interval : float = 2.0  
var last_spawn_time : float = 0.0  
var gravity : float = 980.0
var arc_height : float = 200.0
var avoid_range : float = 300.0 
#var debug_path : Array = []  

func _ready():
	set_process(true)

func _process(delta):
	last_spawn_time += delta
	if last_spawn_time >= stone_spawn_interval:
		spawn_stone()
		last_spawn_time = 0.0

#func _draw():
	#if debug_path.size() > 1:
	#	for i in range(debug_path.size() - 1):
	#		draw_line(debug_path[i] - global_position, debug_path[i + 1] - global_position, Color.RED, 2.0)

func spawn_stone():
	var target_position = target_node.global_position

	var start_position : Vector2
	if randf() > 0.8:  
		var random_x = randf_range(0, get_viewport().size.x)

		while abs(random_x - target_position.x) < avoid_range:
			random_x = randf_range(0, get_viewport().size.x)
		start_position = Vector2(random_x, -50)  
	else:
		var random_y = randf_range(0, get_viewport().size.y)
		if randf() > 0.5:
			start_position = Vector2(-50, random_y)  
		else:
			start_position = Vector2(get_viewport().size.x + 50, random_y)  

	start_position = to_global(start_position)

	var velocity = calculate_arc_velocity(start_position, target_position, arc_height)
	#predict_trajectory(start_position, velocity)  

	var stone_instance = stone_scene.instantiate()  
	add_child(stone_instance)

	stone_instance.global_position = start_position
	stone_instance.set("velocity", velocity)
	stone_instance.set("angular_velocity", randf_range(-5.0, 5.0))

	#_draw()  

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

'''
func predict_trajectory(start_pos: Vector2, initial_velocity: Vector2):
	debug_path.clear()
	var pos = start_pos
	var vel = initial_velocity
	var delta = 0.016  
	var steps = 100  

	for i in range(steps):
		debug_path.append(pos)
		vel.y += gravity * delta
		pos += vel * delta

		if pos.y > target_node.global_position.y and vel.y > 0:
			break
'''

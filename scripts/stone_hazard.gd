extends Node2D

@export var target_node : Node2D

var stone_speed : float = 400.0  # Base speed (affects time of flight, adjustable)
var stone_spawn_interval : float = 2.0  
var last_spawn_time : float = 0.0  
var gravity : float = 500.0  # Must match stone.gd's gravity

@export var stone_scene : PackedScene  

func _ready():
	set_process(true)

func _process(delta):
	last_spawn_time += delta
	if last_spawn_time >= stone_spawn_interval:
		spawn_stone()
		last_spawn_time = 0.0
		
func spawn_stone():
	var target_position = target_node.position  
	var start_position : Vector2

	# Random spawn position (unchanged)
	if randf() > 0.5:  
		var random_x = randf_range(0, get_viewport().size.x)
		start_position = Vector2(random_x, -50)  
	else:
		var random_y = randf_range(0, get_viewport().size.y)
		if randf() > 0.5:
			start_position = Vector2(-50, random_y)  
		else:
			start_position = Vector2(get_viewport().size.x + 50, random_y)  

	# Calculate displacement to target
	var delta_x = target_position.x - start_position.x
	var delta_y = target_position.y - start_position.y
	
	# Calculate time of flight based on horizontal speed
	var time_of_flight = abs(delta_x) / stone_speed
	
	# Calculate initial vertical velocity to hit the target (projectile motion)
	var initial_vy = (delta_y - 0.5 * gravity * time_of_flight * time_of_flight) / time_of_flight
	
	# Set initial velocity
	var initial_velocity = Vector2(
		stone_speed if delta_x > 0 else -stone_speed,  # Horizontal direction
		-initial_vy  # Negative because Godot's Y-axis is down
	)

	# Instantiate and set up the stone
	var stone_instance = stone_scene.instantiate()  
	add_child(stone_instance)
	
	stone_instance.position = start_position
	stone_instance.velocity = initial_velocity
	
	# Randomize rotation speed for variety
	stone_instance.rotation_speed = randf_range(180.0, 360.0)

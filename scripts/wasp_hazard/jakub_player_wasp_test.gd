extends CharacterBody2D

@onready var shield = $Shield  # Assuming your shield is a child node of the player

var last_shield_position: Vector2
var shield_speed: float = 0.0
var wave_threshold: float = 3000.0  # Minimum movement speed to count as waving
var center_position: Vector2
var shield_distance: float  # The fixed distance from the player's center to the shield

func _ready():
	center_position = global_position  # Set the player position as the center
	shield_distance = (shield.global_position - center_position).length()  # Calculate the initial distance
	last_shield_position = shield.global_position

func _process(delta):
	# Get the direction vector from the player to the mouse
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - center_position).normalized()

	# Calculate the angle of rotation (in radians) for the shield
	var angle_to_mouse = direction_to_mouse.angle()
	# Calculate the new position of the shield based on the fixed radius (shield_distance)
	var shield_position = center_position + Vector2(cos(angle_to_mouse), sin(angle_to_mouse)) * shield_distance

	# Move the shield to the new calculated position
	shield.global_position = shield_position

	# Set the shield's rotation so that it always faces the mouse
	shield.rotation = angle_to_mouse+ PI / 2

	# Calculate shield movement speed for waving detection
	shield_speed = (shield.global_position - last_shield_position).length() / delta
	last_shield_position = shield.global_position

	# Check for wasp repelling
	for wasp in get_tree().get_nodes_in_group("wasps"):
		if shield_speed > wave_threshold and shield.global_position.distance_to(wasp.global_position) < 70:
			wasp.scare_away()

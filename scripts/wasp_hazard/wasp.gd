extends Node2D

@export var speed: float = 100.0
@export var escape_speed: float = 300.0
@export var avoid_range: float = 100.0
@export var amplitude: float = 20.0
@export var frequency: float = 5.0
@export var infinity_size: float = 130.0
@export var transition_duration: float = 2.0 
@export var y_target_offset: float = -220.0  # Add an offset to target the player's head

var player: Node2D
var fleeing: bool = false
var time: float = 0.0
var arrived: bool = false
var transitioning: bool = false
var transition_time: float = 0.0

@onready var damage_timer: Timer = $DamageTimer

func _ready():
	# Ensure wasp is always rendered above the player
	z_index = 10  

	var players = get_tree().get_nodes_in_group("Player")
	if players.is_empty():
		print("Player not found!")
		queue_free()
		return

	player = players[0]

	var start_position: Vector2
	if randf() > 0.8:
		var random_x = randf_range(0, get_viewport().size.x)
		while abs(random_x - player.global_position.x) < avoid_range:
			random_x = randf_range(0, get_viewport().size.x)
		start_position = Vector2(random_x, -50)
	else:
		var random_y = randf_range(0, get_viewport().size.y)
		if randf() > 0.5:
			start_position = Vector2(-50, random_y)
		else:
			start_position = Vector2(get_viewport().size.x + 50, random_y)

	# Adjust start position based on y_target_offset
	global_position = start_position + Vector2(0, y_target_offset)

func _process(delta):
	time += delta

	if fleeing:
		global_position += (global_position - player.global_position).normalized() * escape_speed * delta
		if not get_viewport_rect().has_point(global_position):
			queue_free()
	elif arrived:
		# Infinity movement around player
		var offset_x = cos(time * 2.0) * infinity_size
		var offset_y = sin(time * 4.0) * infinity_size * 0.5
		global_position = player.global_position + Vector2(offset_x, offset_y + y_target_offset)  # Adjusted for the head
	elif transitioning:
		# Smooth transition to infinity movement
		transition_time += delta
		var t = clamp(transition_time / transition_duration, 0.0, 1.0)

		var target_offset_x = cos(time * 2.0) * infinity_size
		var target_offset_y = sin(time * 4.0) * infinity_size * 0.5
		var target_position = player.global_position + Vector2(target_offset_x, target_offset_y + y_target_offset)  # Adjusted for the head

		global_position = global_position.lerp(target_position, t)

		if t >= 1.0:
			transitioning = false
			arrived = true
			_start_damage_timer()  # Start dealing damage once wasp arrives
	else:
		# Sinusoidal approach towards player, adjusted to the target head offset
		var direction = (player.global_position + Vector2(0, y_target_offset) - global_position).normalized()  # Add y_target_offset here
		var perpendicular = Vector2(-direction.y, direction.x)
		var sinus_offset = sin(time * frequency) * amplitude

		global_position += direction * speed * delta + perpendicular * sinus_offset * delta

		if global_position.distance_to(player.global_position + Vector2(0, y_target_offset)) < 10.0:  # Adjust distance check to account for the offset
			transitioning = true
			transition_time = 0.0

# Function to start damage timer
func _start_damage_timer():
	damage_timer.wait_time = 1.0
	damage_timer.timeout.connect(_deal_damage)
	add_child(damage_timer)
	damage_timer.start()

# Function to deal damage
func _deal_damage():
	GameManager.adjust_balance(-5)
	GameManager.adjust_charisma(-3)
	damage_timer.wait_time = 2.0  # Next hits every 5 seconds
	damage_timer.start()
	print("AUAU")

# Function to scare away the wasp
func scare_away():
	fleeing = true
	arrived = false
	transitioning = false

	if damage_timer and damage_timer.is_inside_tree():
		damage_timer.stop()

extends CharacterBody2D

const SPEED = 300.0

# THE THREE BARS
var oxygen: float = 100
var reputation: float = 100
var wobbling: float = 100

@onready var npc_spawn_point = $NPC_spawn_point

# which NPC am I interacting with?
enum CurrentNPC {PRIEST, BANDIT, DRUNKARD, PRINCESS, NOONE}
var NPC_on_screen: CurrentNPC = CurrentNPC.PRIEST

# PRAYING
var is_in_praying_zone: bool = false
var is_praying: bool = false
var not_praying_reputation_penalty_per_second: float = 10

# BANDIT HIT
var bandit_hit_decrease_wobble: float = 30

@onready var skeleton_container = $SkeletonContainer

@onready var shield = $Shield 
var last_shield_position: Vector2
var shield_speed: float = 0.0
@export var wave_threshold: float = 3000.0  # Minimum movement speed to count as waving
var center_position: Vector2
@export var shield_distance: float = 80.0  # Adjustable distance of the shield from the player
var shield_y_offset: float = -140


#Oxygen


func _ready():
	GameManager.camera = $Camera2D
	center_position = global_position  
	center_position.y += shield_y_offset  # Set the player's upper body position as the center
	last_shield_position = shield.global_position

func _process(delta):
	#print(reputation)
	#print(is_praying)
	if is_in_praying_zone and !is_praying:
		reputation = reputation - not_praying_reputation_penalty_per_second * delta
		
	handle_input()
	

func _physics_process(delta):

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		skeleton_container.play_walk_animation()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		skeleton_container.play_stand_animation()

	move_and_slide()
	
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - center_position).normalized()

	var angle_to_mouse = direction_to_mouse.angle()
	center_position = global_position
	center_position.y += shield_y_offset

	# Adjust the shield position relative to the player (use shield_distance and angle_to_mouse)
	var shield_position = center_position + Vector2(cos(angle_to_mouse), sin(angle_to_mouse)) * shield_distance

	# Add the Y offset to shield position
	shield_position.y += shield_y_offset

	shield.global_position = shield_position

	shield.rotation = angle_to_mouse + PI / 2

	# Calculate shield movement speed based on position change
	shield_speed = (shield.global_position - last_shield_position).length() / delta
	last_shield_position = shield.global_position

	# Scare wasps away if shield is moving fast enough
	for wasp in get_tree().get_nodes_in_group("wasps"):
		if shield_speed > wave_threshold and shield.global_position.distance_to(wasp.global_position) < 70:
			wasp.scare_away()

# player input
func handle_input():
	if Input.is_action_pressed("PerformAction") and NPC_on_screen == CurrentNPC.PRIEST:
		is_praying = true
	else:
		is_praying = false

# NPC interaction functions
func enter_praying_zone():
	is_in_praying_zone = true
	
func exit_praying_zone():
	is_in_praying_zone = false
	
func get_npc_spawn_point_position():
	return position + npc_spawn_point.position
	
func hit_by_bandit():
	print("I got hit by a bandit!")
	wobbling = wobbling - bandit_hit_decrease_wobble
	

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
@onready var ik_target = $SkeletonContainer/IKTargetWholeLeftArm  # The IK target for the arm

@export var wave_threshold: float = 3000.0  # Minimum movement speed to count as waving
var last_ik_position: Vector2
var ik_speed: float = 0.0


#Oxygen


func _ready():
	GameManager.camera = $Camera2D
	last_ik_position = ik_target.global_position

func _process(delta):
	if is_in_praying_zone and !is_praying:
		reputation -= not_praying_reputation_penalty_per_second * delta

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
	
	# Move the IK target to follow the mouse position
	ik_target.global_position = get_global_mouse_position()

	# Calculate movement speed of the IK target
	ik_speed = (ik_target.global_position - last_ik_position).length() / delta
	last_ik_position = ik_target.global_position

	# Scare wasps away if arm is moving fast enough
	for wasp in get_tree().get_nodes_in_group("wasps"):
		if ik_speed > wave_threshold and ik_target.global_position.distance_to(wasp.global_position) < 70:
			wasp.scare_away()

# Player input
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
<<<<<<< HEAD
	wobbling = wobbling - bandit_hit_decrease_wobble
	
=======
	wobbling -= bandit_hit_decrease_wobble
>>>>>>> origin/jakub5

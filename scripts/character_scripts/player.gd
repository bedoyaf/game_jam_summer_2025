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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	



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

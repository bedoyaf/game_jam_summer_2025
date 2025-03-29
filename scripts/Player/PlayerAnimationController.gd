extends Node

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true
	play_walk_animation()


var is_standing = true
func _process(delta):
	if is_standing and Input.is_action_just_released("Test"):
		is_standing = false  # "move_left" corresponds to the "A" key
		play_walk_animation()
	
	elif !is_standing and Input.is_action_just_released("Test"):
		is_standing = true
		play_stand_animation()


func play_walk_animation():
	state_machine.travel("Walking")  # Switch to walking animation

func play_stand_animation():
	state_machine.travel("standing")  # Switch to standing animation

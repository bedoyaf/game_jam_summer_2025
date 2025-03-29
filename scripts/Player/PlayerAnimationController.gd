extends Node

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var balanceUI
@export var max_rotation: float = 30.0

func _ready():
	animation_tree.active = true
	play_walk_animation()
	balanceUI = UI.get_node("Balance")



func play_walk_animation():
	state_machine.travel("Walking")  # Switch to walking animation

func play_stand_animation():
	state_machine.travel("standing")  # Switch to standing animation

func _process(delta):
	if not balanceUI:
		return
		# Use the amplitude from the UI script to control rotation
	var wiggle_angle = balanceUI.currentSadam*10
	print(wiggle_angle)
	# Clamp the angle and convert to radians
	self.rotation = deg_to_rad(clamp(wiggle_angle, -max_rotation*balanceUI.balance, max_rotation*balanceUI.balance))

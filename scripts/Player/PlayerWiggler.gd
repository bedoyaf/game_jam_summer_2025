extends Node


var balanceUI
@export var max_rotation: float = 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	balanceUI = UI.get_node("Balance")



func _process(delta):
	if not balanceUI:
		return
		# Use the amplitude from the UI script to control rotation
	var wiggle_angle = balanceUI.currentSadam*10

	# Clamp the angle and convert to radians
	self.rotation = deg_to_rad(clamp(wiggle_angle, -max_rotation*balanceUI.balance, max_rotation*balanceUI.balance))

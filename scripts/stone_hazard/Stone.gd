extends RigidBody2D

var is_in_viewport : bool = false  

@export var gravity2 : float = 850.0  # Gravity multiplier

func _ready():
	# Enable Continuous Collision Detection to prevent tunneling
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY  

func _integrate_forces(state: PhysicsDirectBodyState2D):
	linear_velocity.y += gravity2 * state.step

	# Apply rotation
	angular_velocity = clamp(angular_velocity, -5.0, 5.0)  # Prevent excessive spin
	rotation += angular_velocity * state.step

	# Check if stone exits the screen
	if not is_in_viewport and $VisibleOnScreenNotifier2D.is_on_screen():
		is_in_viewport = true

	if is_in_viewport and not $VisibleOnScreenNotifier2D.is_on_screen():
		if position.y > get_viewport().size.y:
			queue_free()

# Destroy the stone after a timeout
func _on_destroy_timer_timeout() -> void:
	queue_free()

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	# Check if colliding with player
	if body.is_in_group("Player"):
		GameManager.adjust_balance(-10)
		GameManager.adjust_charisma(-5)
		queue_free()  # Destroy the stone
		return  # Exit early to prevent further processing

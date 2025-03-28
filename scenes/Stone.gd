extends Area2D

var velocity : Vector2 = Vector2.ZERO
var rotation_speed : float = 360.0  # Degrees per second (adjustable)
var is_in_viewport : bool = false

func _process(delta):
	# Update position with velocity
	position += velocity * delta
	
	# Apply gravity to vertical velocity
	velocity.y += gravity * delta
	
	# Rotate the stone
	rotation_degrees += rotation_speed * delta
	
	# Check if stone enters/leaves the viewport
	if not is_in_viewport and $VisibleOnScreenNotifier2D.is_on_screen():
		is_in_viewport = true
	if is_in_viewport and not $VisibleOnScreenNotifier2D.is_on_screen():
		queue_free()
		print("Stone removed")

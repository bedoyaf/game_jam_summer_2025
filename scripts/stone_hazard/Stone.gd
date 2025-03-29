extends CharacterBody2D

var angular_velocity : float = 0.0 
var is_in_viewport : bool = false  
var gravity2 : float = 980.0

func _physics_process(delta: float) -> void:

	velocity.y += gravity2 * delta

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.is_in_group("Player"):
					GameManager.adjust_balance(-10)
					GameManager.adjust_charisma(-5)
					queue_free()  # Destroy the stone
		else:
			var bounce_factor = 1.0
			if collider is PhysicsBody2D and "physics_material_override" in collider:
				var physics_material = collider.physics_material_override
				if physics_material:
					bounce_factor = physics_material.bounce

			var normal = collision_info.get_normal()
			velocity = velocity.bounce(normal) * bounce_factor

	rotation += angular_velocity * delta

	if not is_in_viewport and $VisibleOnScreenNotifier2D.is_on_screen():
		is_in_viewport = true

	if is_in_viewport and not $VisibleOnScreenNotifier2D.is_on_screen():

		if position.y > get_viewport().size.y:
			queue_free()
			#print("Stone destroyed")


func _on_destroy_timer_timeout() -> void:
	queue_free() 

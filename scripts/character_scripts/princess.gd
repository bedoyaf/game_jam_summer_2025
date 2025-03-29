extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta



	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		UI.princess_start_dialogue()
		GameManager.is_in_goal = true

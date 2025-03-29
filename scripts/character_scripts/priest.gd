extends CharacterBody2D


const SPEED = 150.0


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = -SPEED
	move_and_slide()


func _on_is_visible_notifier_screen_exited():
	var root = get_tree().current_scene
	for child in root.get_children():
		if child.is_in_group("NPCSpawner"):
			child.notify_npc_left_screen()
	queue_free()
	print("The PRIEST is DEAD.")

extends Area2D




func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("ENTER praying zone.")
		body.enter_praying_zone()



func _on_body_exited(body):
	if body.is_in_group("Player"):
		print("EXIT praying zone.")
		body.exit_praying_zone()

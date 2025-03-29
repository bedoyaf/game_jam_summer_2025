extends Area2D




func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("ENTER playing zone.")
		body.enter_praying_zone()



func _on_body_exited(body):
	if body.is_in_group("Player"):
		print("EXIT playing zone.")
		body.exit_praying_zone()

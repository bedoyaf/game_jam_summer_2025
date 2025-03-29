extends Node2D

@onready var timer = $Timer  # Get the Timer node

func _ready():
	timer.start()  # Start the countdown

func _on_Timer_timeout():
	print("Time's up!")  # This runs after 2 minutes
	stop_game()  # Call a function to stop the game

func stop_game():
	#get_tree().paused = true  # Example: Pause the game
	pass

extends CanvasLayer

enum GameState { MainMenu, Normal, GameOver }
@onready var balance = $Balance
@onready var game_over = $GameOver
@onready var princess_dialogue = $PrincessDialogue


var current_game_state: GameState = GameState.MainMenu

var death_reason: GameManager.DeathReason

func _process(delta):
	if current_game_state == GameState.MainMenu:
		balance.visible = false
		game_over.visible = false
	if current_game_state == GameState.Normal:
		balance.visible = true
		game_over.visible = false
	if current_game_state == GameState.GameOver:
		balance.visible = false
		game_over.visible = true


func change_game_state(game_state):
	print(game_state)
	current_game_state = game_state
	
	if current_game_state == GameState.GameOver:
		game_over.change_death_reason_label(death_reason)
		
			
	
func give_death_reason(reason: GameManager.DeathReason):
	death_reason = reason
	
func princess_start_dialogue():
	princess_dialogue.visible = true
	princess_dialogue.start_dialogue()
	
	
func kill_all_wasps():
	#print("Killing all wasps.")
	#for child in get_tree().get_root().get_children():
		#if child.get_name() == "main_game_level":
			#print("YES IT IS")
			#for child2 in child.get_children():
				#print(child2)
				#if child2.is_in_group("wasps"):
					#print("waspkilled")
					#child.queue_free()
	for child in GameManager.get_children():
		if child.is_in_group("wasps"):
			print("waspkilled")
			child.queue_free()
	
	
	

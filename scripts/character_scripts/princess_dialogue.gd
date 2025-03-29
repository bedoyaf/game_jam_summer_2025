extends Control

@onready var label = $Label

var princess_0_success: String = "Mine eyes have followed thy deeds with wonder, thy sword gleaming in righteous purpose. Thy courage hath moved my heart in ways I dare not fully speak."
var princess_1_success: String = "Many a valiant man hath sought my favor, yet none hath shown such gallantry nor such gentle strength as thee."
var princess_2_success: String = "I choose you."

var princess_0_failure: String = "I hate you, placeholder"
var princess_1_failure: String = "You are so so so so ugly ugly ugly."
var princess_2_failure: String = "I though you were a hero, but you are two zeroes."


var array_princess_success: Array = [princess_0_success, princess_1_success, princess_2_success]
var array_princess_failure: Array = [princess_0_failure, princess_1_failure, princess_2_failure]
var actual_dialogue: Array
var dialogue_length: int
var dialogue_index: int = -1

var is_writing_string: bool = false
var is_dialogue_started: bool = false

func _ready():
	print("here1")
	start_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dialogue_started:
		
		if Input.is_action_just_pressed("PerformAction"):
			print(dialogue_index)
			#print("here4")
			if is_writing_string:
				label.text = actual_dialogue[dialogue_index]
				is_writing_string = false
				#dialogue_index += 1
			else:
				#print("here7")
				if dialogue_index < dialogue_length - 1:
					dialogue_index += 1
					is_writing_string = true
					print("calling display with index = " + str(dialogue_index))
					display_text(actual_dialogue[dialogue_index])
				else:
					#print("here8")
					label.visible = false
					queue_free()
					#get_tree().quit()
					UI.change_game_state(UI.GameState.MainMenu)
		
	
	
func start_dialogue():
	#print("here2")
	if GameManager.charisma < 10:
		actual_dialogue = array_princess_success
	else:
		actual_dialogue = array_princess_failure 
	dialogue_length = len(actual_dialogue)
	print(dialogue_length)
	is_dialogue_started = true
	
	
		

func display_text(str_diag: String):
	#print("called with strdiag = " + str_diag)
	if is_writing_string:
		#print("here6")
		var string_now: String = ""
		for char in str_diag:
			string_now = string_now + char
			label.text = string_now
			await get_tree().create_timer(0.02).timeout
			if !is_writing_string:
				return
		is_writing_string = false

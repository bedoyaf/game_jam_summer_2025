extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var quit_button = $VBoxContainer/QuitButton

@onready var sprite_b_1 = $VBoxContainer/PlayButton/SpriteB1
@onready var sprite_b_2 = $VBoxContainer/OptionsButton/SpriteB2
@onready var sprite_b_3 = $VBoxContainer/QuitButton/SpriteB3
const UiManager = preload("res://scenes/UI/ui_manager.gd")


var start_modulate: float = 0
var tween_length: float = 0.2

func _ready():
	play_button.connect("mouse_entered", Callable(self, "_on_mouse_entered_play"))
	play_button.connect("mouse_exited", Callable(self, "_on_mouse_exited_play"))
	
	options_button.connect("mouse_entered", Callable(self, "_on_mouse_entered_options"))
	options_button.connect("mouse_exited", Callable(self, "_on_mouse_exited_options"))
	
	quit_button.connect("mouse_entered", Callable(self, "_on_mouse_entered_quit"))
	quit_button.connect("mouse_exited", Callable(self, "_on_mouse_exited_quit"))
	
	sprite_b_1.self_modulate.a = start_modulate
	sprite_b_2.self_modulate.a = start_modulate
	sprite_b_3.self_modulate.a = start_modulate


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/full_screen_scenes/main_scene_martin.tscn")
	UI.change_game_state(UI.GameState.Normal)


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()



func _on_mouse_entered_play():
	var tween = create_tween()
	tween.tween_property(sprite_b_1, "self_modulate:a", 1, tween_length)
	
func _on_mouse_exited_play():
	var tween = create_tween()
	tween.tween_property(sprite_b_1, "self_modulate:a", 0, tween_length)
	
func _on_mouse_entered_options():
	var tween = create_tween()
	tween.tween_property(sprite_b_2, "self_modulate:a", 1, tween_length)
	
func _on_mouse_exited_options():
	var tween = create_tween()
	tween.tween_property(sprite_b_2, "self_modulate:a", 0, tween_length)

func _on_mouse_entered_quit():
	var tween = create_tween()
	tween.tween_property(sprite_b_3, "self_modulate:a", 1, tween_length)
	
func _on_mouse_exited_quit():
	var tween = create_tween()
	tween.tween_property(sprite_b_3, "self_modulate:a", 0, tween_length)

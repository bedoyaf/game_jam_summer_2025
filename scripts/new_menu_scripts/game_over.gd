extends Control
@onready var play_button = $VBoxContainer/PlayButton
@onready var quit_button = $VBoxContainer/QuitButton

@onready var sprite_b_1 = $VBoxContainer/PlayButton/SpriteB1
@onready var sprite_b_3 = $VBoxContainer/QuitButton/SpriteB3





var start_modulate: float = 0
var tween_length: float = 0.2

func _ready():
	play_button.connect("mouse_entered", Callable(self, "_on_mouse_entered_play"))
	play_button.connect("mouse_exited", Callable(self, "_on_mouse_exited_play"))
	
	
	quit_button.connect("mouse_entered", Callable(self, "_on_mouse_entered_quit"))
	quit_button.connect("mouse_exited", Callable(self, "_on_mouse_exited_quit"))
	
	sprite_b_1.self_modulate.a = start_modulate
	sprite_b_3.self_modulate.a = start_modulate


func _on_play_button_pressed():
	#get_tree().reload_current_scene()
	get_tree().call_deferred("reload_current_scene")



func _on_options_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()



func _on_mouse_entered_play():
	var tween = create_tween()
	tween.tween_property(sprite_b_1, "self_modulate:a", 1, tween_length)
	#sprite_b_1.self_modulate.a = 1
	print("Mouse is hovering over the button")
	
func _on_mouse_exited_play():
	var tween = create_tween()
	tween.tween_property(sprite_b_1, "self_modulate:a", 0, tween_length)
	

func _on_mouse_entered_quit():
	var tween = create_tween()
	tween.tween_property(sprite_b_3, "self_modulate:a", 1, tween_length)
	print("Mouse is hovering over the button")
	
func _on_mouse_exited_quit():
	var tween = create_tween()
	tween.tween_property(sprite_b_3, "self_modulate:a", 0, tween_length)

extends Node

var balance : float = 100.0
var charisma : float = 50.0
var oxygen : float = 100.0

var balance_threshold : float = 0.0
var oxygen_threshold : float = 0.0

var wasp_scene: PackedScene = load("res://scenes/Jakuboviny/wasp.tscn")
var wasp_timer: Timer
@export var wasp_spawn_rate: float = 7.0

signal game_over
signal update_ui

func _ready():
	wasp_timer = Timer.new()
	wasp_timer.wait_time = wasp_spawn_rate
	wasp_timer.autostart = true
	wasp_timer.timeout.connect(_on_WaspTimer_timeout)
	add_child(wasp_timer)

	
func _on_WaspTimer_timeout():
	if randf() < 0.5:
		var wasp = wasp_scene.instantiate()
		add_child(wasp)

func adjust_balance(amount : float):
	balance += amount
	#if balance <= balance_threshold:
		#_trigger_game_over("Rovnováha ztracena!")
	#emit_signal("update_ui", "balance", balance)

func adjust_charisma(amount : float):
	charisma += amount
	#emit_signal("update_ui", "charisma", charisma)

func adjust_oxygen(amount : float):
	oxygen += amount
	#if oxygen <= oxygen_threshold:
	#    _trigger_game_over("Kyslík vyčerpán!")
	#emit_signal("update_ui", "oxygen", oxygen)

func _trigger_game_over(reason : String):
	print("Game Over: " + reason)
	#emit_signal("game_over", reason)

func reset_stats():
	balance = 100.0
	charisma = 50.0
	oxygen = 100.0
	#emit_signal("update_ui", "balance", balance)
	#emit_signal("update_ui", "charisma", charisma)
	#emit_signal("update_ui", "oxygen", oxygen)

func _process(delta):

	if oxygen > 0:
		adjust_oxygen(-0.1 * delta)  

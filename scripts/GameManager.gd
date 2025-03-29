extends Node

var balance : float = 100.0
var maxBalance : float = 100.0

var charisma : float = 50.0
var maxCharisma : float = 50.0

var oxygen : float = 100.0
var maxOxygen : float = 100.0

var balance_threshold : float = 0.0
var oxygen_threshold : float = 0.0

var wasp_scene: PackedScene = load("res://scenes/Jakuboviny/wasp.tscn")
var wasp_timer: Timer
@export var wasp_spawn_rate: float = 1.0

enum DeathReason {Oxygen, Balance, Rejection}

signal game_over
signal update_ui

var camera: Camera2D
var is_in_goal: bool = false



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
	if is_in_goal:
		return
	balance += amount
	if balance>maxBalance:
		balance = maxBalance
	elif balance <0:
		balance = 0
	if balance <= balance_threshold:
		_trigger_game_over(DeathReason.Balance)
	#emit_signal("update_ui", "balance", balance)

func adjust_charisma(amount : float):
	if is_in_goal:
		return
	charisma += amount
	if charisma > maxCharisma:
		charisma = maxCharisma
	elif charisma <0:
		charisma = 0
	#emit_signal("update_ui", "charisma", charisma)

func adjust_oxygen(amount : float):
	if is_in_goal:
		return
	oxygen += amount
	print(oxygen)
	if oxygen > maxOxygen:
		oxygen = maxOxygen
	elif oxygen <0:
		oxygen = 0
	if oxygen <= oxygen_threshold:
		_trigger_game_over(DeathReason.Oxygen)
	#emit_signal("update_ui", "oxygen", oxygen)

func _trigger_game_over(reason : DeathReason):
	UI.give_death_reason(reason)
	UI.change_game_state(UI.GameState.GameOver)
	

func reset_stats():
	balance = maxBalance
	charisma = maxCharisma
	oxygen = maxOxygen
	#emit_signal("update_ui", "balance", balance)
	#emit_signal("update_ui", "charisma", charisma)
	#emit_signal("update_ui", "oxygen", oxygen)

func _process(delta):

	if maxBalance > balance:
		adjust_balance(0.05 * delta)  
	if oxygen > 0:
		adjust_oxygen(-1 * delta)  

extends Node

var balance : float = 1.0
var maxBalance : float = 100.0

var charisma : float = 50.0
var maxCharisma : float = 50.0

var oxygen : float = 100.0
var maxOxygen : float = 100.0

var balance_threshold : float = 0.0
var oxygen_threshold : float = 0.0

signal game_over
signal update_ui

func adjust_balance(amount : float):
	balance += amount
	if balance>maxBalance:
		balance = maxBalance
	elif balance <0:
		balance = 0
	#if balance <= balance_threshold:
		#_trigger_game_over("Rovnováha ztracena!")
	#emit_signal("update_ui", "balance", balance)

func adjust_charisma(amount : float):
	charisma += amount
	if charisma > maxCharisma:
		charisma = maxCharisma
	elif charisma <0:
		charisma = 0
	#emit_signal("update_ui", "charisma", charisma)

func adjust_oxygen(amount : float):
	oxygen += amount
	if oxygen > maxOxygen:
		oxygen = maxOxygen
	elif oxygen <0:
		oxygen = 0
	#if oxygen <= oxygen_threshold:
	#    _trigger_game_over("Kyslík vyčerpán!")
	#emit_signal("update_ui", "oxygen", oxygen)

func _trigger_game_over(reason : String):
	print("Game Over: " + reason)
	#emit_signal("game_over", reason)

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
		adjust_oxygen(-0.1 * delta)  

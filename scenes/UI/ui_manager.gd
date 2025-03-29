extends CanvasLayer

enum GameState { MainMenu, Normal, GameOver }
@onready var balance = $Balance
@onready var game_over = $GameOver

var current_game_state: GameState = GameState.MainMenu


func _process(delta):
	print(current_game_state)
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
	current_game_state = game_state

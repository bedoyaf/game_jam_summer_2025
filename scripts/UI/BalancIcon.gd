extends Control  # Can be Node2D if you're working outside UI

@export var base_amplitude: float = 20.0  # Minimum movement range
@export var max_amplitude: float = 250.0  # Maximum oscillation range
@export var frequency: float = 1.0  # Speed of oscillation
@export var balance: float = 1.0  # External value that controls oscillation

var time_elapsed: float = 0.0
var center_x: float

@onready var Icon = $Icon

var currentSadam

var Player

func _ready():
	center_x = Icon.position.x  # Store initial center position

func _process(delta):
	time_elapsed += delta
	var amplitude = base_amplitude + (max_amplitude * balance)  # Scale oscillation by balance
	currentSadam = sin(time_elapsed * frequency)
	Icon.position.x = center_x + sin(time_elapsed * frequency) * amplitude
	
func UpdateBalance(current_balanc):
	balance = current_balanc

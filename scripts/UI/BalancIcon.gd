extends Control  # Can be Node2D if you're working outside UI

@export var base_amplitude: float = 20.0  # Minimum movement range
@export var max_amplitude: float = 300.0  # Maximum oscillation range
@export var frequency: float = 1.0  # Speed of oscillation
@export var balance: float = 1.0  # External value that controls oscillation

var time_elapsed: float = 0.0
var center_x: float
var shaking: bool = false  # Flag to prevent multiple shakes

@onready var Icon = $Visual
@onready var realIcon = $Visual/Icon


var ycoord :float

var shakingTreshold = 0.8

var currentSadam

var Player

@export var shake_duration = 0.1
@export var shake_intensityMax = 5
@export var shake_intensity = 5
@export var shake_count = 10


func _ready():
	center_x = Icon.position.x  # Store initial center position
	ycoord = Icon.position.y

func _process(delta):
	balance = 1- GameManager.balance/ GameManager.maxBalance
	time_elapsed += delta
	var amplitude = base_amplitude + (max_amplitude * balance)  # Scale oscillation by balance
	currentSadam = sin(time_elapsed * frequency)
	Icon.position.x = center_x + sin(time_elapsed * frequency) * amplitude
	
	var threshold = shakingTreshold * sin(time_elapsed * frequency)
	
	if abs(balance) >= abs(threshold) and not shaking:
		shake_intensity = shake_intensityMax*((balance-shakingTreshold)/(1-shakingTreshold))
		start_shake()

func start_shake():
	var tween = create_tween()
  
	shaking = true  # Prevent multiple triggers
	#tween.stop_all()  # Stop previous tweens if any

	var original_position = realIcon.position
	
	var interval = shake_duration /shake_count

	for i in range(shake_count):
		var random_offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		tween.tween_property(realIcon, "position", original_position + random_offset, interval)
		tween.tween_property(realIcon, "position", original_position, interval)


	await tween.finished
	reset_shake()

func reset_shake():
	shaking = false  # Allow shake to trigger again
#	Icon.posiotion.y = ycoord
	
	
	
	
	
func UpdateBalance(current_balanc):
	balance = current_balanc

extends Node2D

@export var speed: float = 100.0
@export var escape_speed: float = 300.0
@export var avoid_range: float = 100.0
@export var amplitude: float = 20.0  # Výška sinusového pohybu
@export var frequency: float = 5.0   # Frekvence sinusového pohybu
@export var infinity_size: float = 130.0 # Velikost osmičky
@export var transition_duration: float = 2.0 # Doba přechodu na osmičku

var player_position: Vector2
var fleeing: bool = false
var time: float = 0.0
var arrived: bool = false  # Jestli už vosa dorazila k hráči
var transitioning: bool = false  # Přechodový stav
var transition_time: float = 0.0  # Čas od začátku přechodu

func _ready():
	var players = get_tree().get_nodes_in_group("Player")
	if players.is_empty():
		print("Player not found!")
		queue_free()
		return

	player_position = players[0].global_position

	var start_position: Vector2
	if randf() > 0.8:
		var random_x = randf_range(0, get_viewport().size.x)
		while abs(random_x - player_position.x) < avoid_range:
			random_x = randf_range(0, get_viewport().size.x)
		start_position = Vector2(random_x, -50)
	else:
		var random_y = randf_range(0, get_viewport().size.y)
		if randf() > 0.5:
			start_position = Vector2(-50, random_y)
		else:
			start_position = Vector2(get_viewport().size.x + 50, random_y)

	global_position = start_position

func _process(delta):
	time += delta

	if fleeing:
		global_position += (global_position - player_position).normalized() * escape_speed * delta
		if not get_viewport_rect().has_point(global_position):
			queue_free()
	elif arrived:
		# Pohyb ve tvaru osmičky
		var offset_x = cos(time * 2.0) * infinity_size
		var offset_y = sin(time * 4.0) * infinity_size * 0.5
		global_position = player_position + Vector2(offset_x, offset_y)
	elif transitioning:
		# Plynulý přechod na osmičku
		transition_time += delta
		var t = clamp(transition_time / transition_duration, 0.0, 1.0)
		
		# Interpolace mezi aktuální pozicí a pozicí osmičky
		var target_offset_x = cos(time * 2.0) * infinity_size
		var target_offset_y = sin(time * 4.0) * infinity_size * 0.5
		var target_position = player_position + Vector2(target_offset_x, target_offset_y)
		
		global_position = global_position.lerp(target_position, t)
		
		if t >= 1.0:
			transitioning = false
			arrived = true
	else:
		# Sinusový pohyb při přibližování k hráči
		var direction = (player_position - global_position).normalized()
		var perpendicular = Vector2(-direction.y, direction.x)  # Vektor kolmý k pohybu
		var sinus_offset = sin(time * frequency) * amplitude  # Sinusový pohyb nahoru/dolů

		global_position += direction * speed * delta + perpendicular * sinus_offset * delta

		if global_position.distance_to(player_position) < 10.0:
			transitioning = true  # Začne přechod na osmičku
			transition_time = 0.0

# Funkce pro odehnání vosy
func scare_away():
	fleeing = true
	arrived = false  # Přestane létat v osmičce
	transitioning = false  # Zruší přechod

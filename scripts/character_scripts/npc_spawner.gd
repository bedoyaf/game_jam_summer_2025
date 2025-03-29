extends Node

const PRIEST_instance = preload("res://scenes/characters_scenes/priest.tscn")
const BANDIT_instance = preload("res://scenes/characters_scenes/bandit.tscn")

@onready var npc_spawn_timer = $NPC_spawn_timer

var array_npc_instances = [PRIEST_instance, BANDIT_instance]

var npc_spawn_rate_seconds: float = 5

var is_npc_spawned: bool = false

var rng: RandomNumberGenerator

func _ready():
	print("here")
	npc_spawn_timer.wait_time = npc_spawn_rate_seconds
	npc_spawn_timer.start()
	rng = RandomNumberGenerator.new()

func _process(delta):
	#if !is_npc_spawned:
		#spawn_npc()
	pass

func spawn_npc():
	var random_npc_index: int = rng.randi_range(0, len(array_npc_instances) - 1)
	
	var spawn_position: Vector2 = Vector2(0, 0)
	var root = get_tree().current_scene
	for child in root.get_children():
		if child.is_in_group("Player"):
			spawn_position = child.get_npc_spawn_point_position()
	
	#var instance = PRIEST_instance.instantiate()
	var instance = array_npc_instances[random_npc_index].instantiate()
	print(instance)
	instance.position = spawn_position
	print("SPWN POS")
	print(spawn_position)
	root.add_child(instance)
	is_npc_spawned = true
	print("npc_spawned")
	
	

func _on_npc_spawn_timer_timeout():
	return
	print("TIMEOUT")
	spawn_npc()
	
func notify_npc_left_screen():
	print("spawner detected npc exiting scene")
	is_npc_spawned = false
	spawn_npc()
	

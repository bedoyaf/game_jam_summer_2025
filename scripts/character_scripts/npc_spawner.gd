extends Node

const PRIEST_instance = preload("res://scenes/characters/priest.tscn")

@onready var npc_spawn_timer = $NPC_spawn_timer

var npc_spawn_rate_seconds: float = 5

var is_npc_spawned: bool = false

func _ready():
	npc_spawn_timer.wait_time = npc_spawn_rate_seconds
	npc_spawn_timer.start()

func _process(delta):
	if !is_npc_spawned:
		spawn_npc()

func spawn_npc():
	var spawn_position: Vector2 = Vector2(0, 0)
	var root = get_tree().current_scene
	for child in root.get_children():
		if child.is_in_group("Player"):
			spawn_position = child.get_npc_spawn_point_position()
	
	var instance = PRIEST_instance.instantiate()
	instance.position = spawn_position
	root.add_child(instance)
	is_npc_spawned = true
	
	

func _on_npc_spawn_timer_timeout():
	return
	print("TIMEOUT")
	spawn_npc()
	
func notify_npc_left_screen():
	print("spawner detected npc exiting scene")
	is_npc_spawned = false

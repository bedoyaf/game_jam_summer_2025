extends CharacterBody2D


var SPEED: float = 300.0

@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	#animationPlayer.play("WalkingBandit")
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = -SPEED
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.hit_by_bandit()
		SPEED = SPEED * 2


func _on_is_visible_notifier_screen_exited():
	var root = get_tree().current_scene
	for child in root.get_children():
		if child.is_in_group("NPCSpawner"):
			child.notify_npc_left_screen()
	queue_free()
	print("The BANDIT is DEAD.")

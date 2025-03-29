extends Camera2D

var speed_camera = 300

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x = position.x - speed_camera * delta
	if Input.is_action_pressed("ui_right"):
		position.x = position.x + speed_camera * delta
	if Input.is_action_pressed("ui_up"):
		position.y = position.y - speed_camera * delta
	if Input.is_action_pressed("ui_down"):
		position.y = position.y + speed_camera * delta

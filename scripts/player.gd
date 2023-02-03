extends Entity

func _process(delta):
	# - MOVEMENT
	var inputs = Vector2.ZERO
	if Input.is_action_pressed("left"):
		inputs.x -= 1
	if Input.is_action_pressed("right"):
		inputs.x += 1
	if Input.is_action_pressed("up"):
		inputs.y -= 1
	if Input.is_action_pressed("down"):
		inputs.y += 1
	
	position += inputs * delta * accel


func _draw():
	# - DEBUG
	draw_circle(Vector2.ZERO, 4, Color(255, 255, 255))

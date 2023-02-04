extends Entity

func _ready():
	attack = 100
	accel = Vector2(1000, 1000)
	sprite = $sprite
	healthColor = Color(0, 255, 0)
	makeHeart()

func getInputs(delta):
	# - MOVEMENT
	if !attacking:
		if Input.is_action_pressed("left"):
			inputs.x -= 1
		if Input.is_action_pressed("right"):
			inputs.x += 1
		if Input.is_action_pressed("up"):
			inputs.y -= 1
		if Input.is_action_pressed("down"):
			inputs.y += 1
	
	# - ATTACK
	if Input.is_action_just_pressed("attack"):
		attack()

func _draw():
	# - DEBUG
#	draw_circle(Vector2.ZERO, 16, Color(255, 255, 255))
	pass

func attack():
	meleeAttack(get_mouse_position_actual(), 0.3, 0)

func get_mouse_position_actual():
	return get_global_mouse_position() - self.global_position - Vector2(256, 153)

func _on_sprite_animation_finished():
	$sprite.animation = "idle"

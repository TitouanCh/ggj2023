extends Entity

func getInputs():
	# - MOVEMENT
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
	var a = damageZone.instance()
	self.add_child(a)
	a.position = -(self.global_position - (get_global_mouse_position()/Vector2(2, 2))).normalized() * meleeRange

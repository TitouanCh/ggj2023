extends Node2D

signal unlock_ability

var unlocked = false

func _draw():
	for child in get_children():
		draw_line(Vector2.ZERO, child.position, Color(255, 255, 255))

func _process(delta):
	if get_mouse_position_actual().distance_to(global_position) < 16:
		self.modulate = Color(0, 80, 0)
		if Input.is_action_just_pressed("click"):
			emit_signal("unlock_ability")
	else:
		self.modulate = Color(255, 255, 255)
	update()
#	$test.global_position = get_global_mouse_position()/2 + Vector2(-27, 24)

func get_mouse_position_actual():
#	print(get_global_mouse_position())
	return get_global_mouse_position()/2 + Vector2(-27, 24)

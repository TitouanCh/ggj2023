extends Node2D

func _draw():
	for child in get_children():
		draw_line(Vector2.ZERO, child.position, Color(255, 255, 255))

func _process(delta):
	if name == "test1":
		self.modulate = Color(0, 255, 0)
		print(get_local_mouse_position() - Vector2(256, 135))

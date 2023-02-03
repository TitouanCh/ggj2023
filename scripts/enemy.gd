extends Entity

func _draw():
	# - DEBUG
	draw_circle(Vector2.ZERO, 16, Color(255, 0, 0))

func _draw_line():
	draw_line(Vector2.ZERO, Vector2(50, 50), Color(255, 0, 0), 1)

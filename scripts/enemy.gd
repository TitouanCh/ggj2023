extends Entity

func _draw():
	# - DEBUG
#	draw_circle(Vector2.ZERO, 16, Color(255, 0, 0))
	pass

func _draw_line():
	draw_line(Vector2.ZERO, Vector2(50, 50), Color(255, 0, 0), 1)

func die():
	print(self.name + " is dead.")
	get_parent().reduceEnemyCount()
	queue_free()

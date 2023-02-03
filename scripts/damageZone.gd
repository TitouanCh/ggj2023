extends Area2D

# In s
var timeAlive = 0.05

func _process(delta):
	timeAlive -= delta
	if timeAlive <= 0:
		queue_free()

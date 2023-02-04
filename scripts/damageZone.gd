extends Area2D

# In s
var timeAlive = 0.1

func _ready():
	$sprite.playing = true

func _process(delta):
	timeAlive -= delta
	if timeAlive <= 0:
		queue_free()

func _on_damageZone_body_entered(body):
	if body != get_parent():
		body.takeDamage(get_parent())

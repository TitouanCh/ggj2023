extends AnimatedSprite

var destroy = false

func _ready():
	get_parent().bodies.append(self)

func _on_body_animation_finished():
	self.playing = false
	self.frame = 3

func _process(delta):
	self.modulate = self.modulate.linear_interpolate(Color(0.5, 0.5, 0.5), delta * 2)
	if destroy:
		self.modulate = self.modulate.linear_interpolate(Color(0, 0, 0, 0), delta * 6)

func destroy():
	$particles.emitting = true
	destroy = true
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

extends AnimatedSprite

var destroy = false
var vide = false

func _ready():
	get_parent().bodies.append(self)

func _on_body_animation_finished():
	self.playing = false
	self.frame = 3

func _process(delta):
	self.modulate = self.modulate.linear_interpolate(Color(0.5, 0.5, 0.5), delta * 2)
	if destroy:
		self.modulate = self.modulate.linear_interpolate(Color(0, 0, 0, 0), delta * 6)
	
	if vide:
		self.position += self.position.normalized() * delta * 10
	
	if !vide:
		if abs(position.x) >= 600:
			vide = true
		if abs(position.y) >= 450:
			vide = true

func destroy():
	$particles.emitting = true
	destroy = true
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

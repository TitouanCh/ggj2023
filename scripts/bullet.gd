extends RigidBody2D

var time = 5
var Tdelta = 0
var damaging = true

func _process(delta):
	$sprite.rotation = linear_velocity.angle()
	Tdelta += delta
	if Tdelta > time:
		queue_free()

func takeDamage(attacker):
	linear_velocity = (attacker.position - self.position).normalized() * 30

func _on_Area2D_body_entered(body):
	if body != self:
		$sprite.modulate = Color(0, 0, 0)
		if body is KinematicBody2D and damaging:
			body.takeDamage(get_parent(), get_parent().shootMod)
			damaging = false

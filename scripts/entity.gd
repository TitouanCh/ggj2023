extends KinematicBody2D

class_name Entity

# - Scenes
var damageZone = preload("res://scenes/damageZone.tscn")

# - General Attributes
var accel = Vector2(500, 500)
var velocity = Vector2(0, 0)
var inputs = Vector2.ZERO
var friction = 0.9

var health = 100
var healthMax = 100

var attack = 25
var defense = 1

# - Specific Attributes
var meleeRange = 22
var knockback = 240

func _physics_process(delta):
	inputs = Vector2.ZERO
	getInputs()
	move(delta)

func getInputs():
	pass

func move(delta):
	velocity += inputs * accel * delta
	velocity *= friction
	
	velocity = move_and_slide(velocity)

func takeDamage(attacker):
	health -= attacker.attack - self.defense
	velocity -= (attacker.position - self.position).normalized() * knockback
	
	if health <= 0:
		die()

func die():
	print(self.name + " is dead.")
	queue_free()

func attack():
	get_global_mouse_position()


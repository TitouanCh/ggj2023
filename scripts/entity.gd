extends KinematicBody2D

class_name Entity

# - Attributes
var accel = Vector2(50, 50)

var health = 100
var healthMax = 100

var attack = 5
var defense = 1

func takeDamage(attacker):
	health -= attacker.attack - self.defense
	if health <= 0:
		die()

func die():
	print(self.name + " is dead.")
	queue_free()

func attack():
	pass

extends KinematicBody2D

class_name Entity

# - Scenes
var damageZone = preload("res://scenes/damageZone.tscn")

# - General Attributes
var accel = Vector2(50, 50)

var health = 100
var healthMax = 100

var attack = 5
var defense = 1

# - Specific Attributes
var meleeRange = 22

func takeDamage(attacker):
	health -= attacker.attack - self.defense
	if health <= 0:
		die()

func die():
	print(self.name + " is dead.")
	queue_free()

func attack():
	get_global_mouse_position()

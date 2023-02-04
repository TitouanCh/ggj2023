extends KinematicBody2D

class_name Entity

# - Scenes
var damageZone = preload("res://scenes/damageZone.tscn")
var fx = preload("res://scenes/fx.tscn")

# - General Attributes
var accel = Vector2(500, 500)
var velocity = Vector2(0, 0)
var inputs = Vector2.ZERO
var friction = 0.9

var health = 100
var healthMax = 100

var attack = 25
var defense = 1

var sprite = null

# - Specific Attributes
var meleeRange = 22
var knockback = 240
var attacking = false


func _physics_process(delta):
	inputs = Vector2.ZERO
	getInputs()
	move(delta)
	z_index = position.y

func getInputs():
	pass

func move(delta):
	# - SPRITE
	if inputs.x != 0: sprite.flip_h = inputs.x < 0
	
	# - MVT
	velocity += inputs * accel * delta
	velocity *= friction
	
	velocity = move_and_slide(velocity)

func takeDamage(attacker):
	health -= attacker.attack - self.defense
	velocity -= (attacker.position - self.position).normalized() * knockback
	
	if health <= 0:
		die()
	
	flicker()
	
func flicker():
	for i in 2:
		modulate = Color(255, 0, 0)
		yield(get_tree().create_timer(0.05), "timeout")
		modulate = Color(1, 1, 1)
		yield(get_tree().create_timer(0.05), "timeout")

func die():
	print(self.name + " is dead.")
	var s = fx.instance()
	get_parent().add_child(s)
	s.global_position = self.position - Vector2(8, 8)
	queue_free()

func attack():
	get_global_mouse_position()

func meleeAttack(target, windUpTime, windDownTime):
	attacking = true
	sprite.animation = "attack"
	sprite.flip_h = target.x < 0
	
	yield(get_tree().create_timer(windUpTime), "timeout")
	var a = damageZone.instance()
	self.add_child(a)
	a.position = target.normalized() * meleeRange
	a.rotation = target.normalized().angle()
	yield(get_tree().create_timer(windDownTime), "timeout")
	
	attacking = false

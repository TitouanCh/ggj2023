extends KinematicBody2D

class_name Entity

# - Scenes
var damageZone = preload("res://scenes/damageZone.tscn")
var fx = preload("res://scenes/fx.tscn")
var body = preload("res://scenes/body.tscn")
var bulletScene = preload("res://scenes/bullet.tscn")
var lifeImage = preload("res://sprites/fx/coeur.png")

# - General Attributes
var accel = Vector2(500, 500)
var velocity = Vector2(0, 0)
var inputs = Vector2.ZERO
var friction = 0.9

var health = 100
var healthMax = 100
var healthAnimation = health
var healthColor = Color(255, 0, 0)

var attack = 25
var defense = 1

var sprite = null
var heart = null
var audio = null
var dead = false

# - Specific Attributes
var meleeRange = 22
var knockback = 240
var attacking = false


func _process(delta):
	healthAnimation = lerp(healthAnimation, health, delta * 10)
	update()

func _physics_process(delta):
	inputs = Vector2.ZERO
	getInputs(delta)
	if !attacking and !dead:
		if inputs != Vector2.ZERO:
			sprite.animation = "walk"
		else:
			sprite.animation = "idle"
	move(delta)
	z_index = position.y

func getInputs(delta):
	pass

func move(delta):
	# - SPRITE
	if inputs.x != 0: sprite.flip_h = inputs.x < 0
	
	# - MVT
	velocity += inputs * accel * delta
	velocity *= friction
	
	velocity = move_and_slide(velocity)

func takeDamage(attacker, damageMod = 1, knockbcakMod = 1):
	health -= attacker.attack * damageMod - self.defense
	velocity -= (attacker.position - self.position).normalized() * knockback * knockbcakMod
	
	if health <= 0:
		get_parent().playSound("mort.wav")
		die()
	else:
		get_parent().playSound("ouch.wav")
	
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
	createBody("player")
	queue_free()

func createBody(type):
	var b = body.instance()
	get_parent().add_child(b)
	b.global_position = self.position
	b.play("dead" + type)

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

func shootAttack(target, speed = 5, wind = 1, windrand = true):
	attacking = true
	sprite.animation = "attack"
	var bullet = bulletScene.instance()
	bullet.position += target.normalized() * 20 + Vector2(0, -1)
	bullet.linear_velocity = target.normalized() * speed * 100
	self.add_child(bullet)
	
	if windrand: wind += randf()
	yield(get_tree().create_timer(wind), "timeout")
	sprite.animation = "idle"
	attacking = false
	
func drawHealthBar():
	draw_rect(Rect2(-11, -21, 22,5), Color(0,0,0))
	draw_rect(Rect2(-10, -20, healthAnimation/healthMax*20,3), healthColor)
	
func  _draw():
	 drawHealthBar()

func makeHeart():
	heart = Sprite.new()
	heart.scale = Vector2(0.5, 0.5)
	heart.z_index = 10000
	self.add_child(heart)
	heart.texture = lifeImage
	heart.position = Vector2 (-12, -19)
	heart.modulate = healthColor

func playSound(sound, rand = true):
	if audio:
		var a = load("res://sounds/" + sound)
		if a:
			if rand: audio.pitch_scale = randf()/10 + 0.9
			audio.stream = a
			audio.play()
			


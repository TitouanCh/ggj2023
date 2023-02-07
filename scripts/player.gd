extends Entity

var dashPower = 700
var dashCooldownMax = 1
var dashCooldown = 0
var dashing = false

var arms = null

func _ready():
	attack = 100
	accel = Vector2(1000, 1000)
	sprite = $sprite
	audio = $audio
	healthColor = Color(0, 255, 0)
	health = 100
	shootMod = 0.2
	makeHeart()
	
	if Global.active_upgrades.has("Shoot"):
		sprite.frames = load("res://spriteframes/playerShoot.tres")


		var newsprite = AnimatedSprite.new()
		self.add_child(newsprite)
		arms = newsprite
		arms.frames = load("res://spriteframes/playerArms.tres")
		arms.animation = "idle"
#		arms.flip_v = true
		arms.position += Vector2(0, -2)
		arms.connect("animation_finished", self, "stopArms")
	else:
		sprite.frames = load("res://spriteframes/player.tres")

func getInputs(delta):
	# - MOVEMENT
	if !attacking:
		if Input.is_action_pressed("left"):
#			playSound("coup_ventre_enemies.wav")
			inputs.x -= 1
		if Input.is_action_pressed("right"):
			inputs.x += 1
		if Input.is_action_pressed("up"):
			inputs.y -= 1
		if Input.is_action_pressed("down"):
			inputs.y += 1
		if Global.active_upgrades.has("Inversion") :
			inputs = -inputs
		
		if Input.is_action_just_pressed("dash") and dashCooldown >= dashCooldownMax:
			dash()
			dashCooldown = 0
	
		# - ATTACK
		if Global.active_upgrades.has("Shoot"):
			if Input.is_action_pressed("attack"):
				attack()
			else:
				arms.animation = "idle"
		else:
			if Input.is_action_just_pressed("attack"):
				attack()
	
	dashCooldown += delta
	if dashCooldown > dashCooldownMax: dashCooldown = dashCooldownMax
	
	if arms:
		arms.flip_v = get_mouse_position_actual().normalized().x < 0
		arms.rotation = lerp_angle(arms.rotation, get_mouse_position_actual().angle(), delta * 5)

func _draw():
	drawHealthBar()
	draw_rect(Rect2(-10, -20, dashCooldown/dashCooldownMax*20,1), Color(255, 255, 255))

func attack():
	if Global.active_upgrades.has("Shoot"):
		get_parent().playSound("gun.wav")
		if arms:
			arms.animation = "attack"
			arms.playing = true
		sprite.flip_h = get_mouse_position_actual().x < 0
		if Global.active_upgrades.has("Dispersion Tir") :
			shootAttack(get_mouse_position_actual().rotated((randf()-0.5)/2), 5, 0.2, false)
		else: shootAttack(get_mouse_position_actual(), 5, 0.2, false)
	else:
		get_parent().playSound("coup_ventre_enemies.wav")
		meleeAttack(get_mouse_position_actual(), 0.3, 0)

func get_mouse_position_actual():
	return get_global_mouse_position() - self.global_position - Vector2(256, 153)

func _on_sprite_animation_finished():
	if attacking and !dead: $sprite.animation = "idle"
	if dead: get_parent().restart()

func dash():
	get_parent().playSound("dash.wav")
	self.modulate = Color(155, 0 , 155)
	velocity += get_mouse_position_actual().normalized() * dashPower
	var a = damageZone.instance()
	a.timeAlive = 0.2
	a.get_node("collisionShape").shape.radius = 16
	a.knockbackMod = 4
	a.damageMod = 0.1
	self.add_child(a)
	yield(get_tree().create_timer(0.2), "timeout")
	self.modulate = Color(1, 1 , 1)

func die():
	playSound("mort_principal.wav")
	print(self.name + " is dead.")
	sprite.animation = "death"
	sprite.frame = 0
	dead = true
	if arms:
		arms.visible = false
	get_parent().playerDied()
	createBody("player")
	$deadGround.visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	$deadGround.color = Color(255, 255, 255)
	yield(get_tree().create_timer(0.1), "timeout")
	$deadGround.color = Color(0, 0, 0)
#	var s = fx.instance()
#	get_parent().add_child(s)
#	s.global_position = self.position - Vector2(8, 8)
	

extends Entity

var player = null
var type = "melee"
var arms = null
var bodyType = 0

func _ready():
	sprite = $sprite
	audio = $audio
	attack = 10
	makeHeart()

func setType(t, i = randi() % 3):
	type = t
	bodyType = i
	if type == "melee":
		if i == 0: sprite.frames = load("res://spriteframes/titouan.tres")
		if i == 1: sprite.frames = load("res://spriteframes/alexandre.tres")
		if i == 2: sprite.frames = load("res://spriteframes/antoine.tres")
	if type == "swat":
		var newsprite = AnimatedSprite.new()
		self.add_child(newsprite)
		arms = newsprite
		
		arms.animation = "idle"
		arms.flip_h = true
		
		arms.connect("animation_finished", self, "stopArms")
		
		if i == 2:
			i = randi() % 2
		bodyType = i
		
		if i == 0:
			sprite.frames = load("res://spriteframes/zephra.tres")
			arms.frames = load("res://spriteframes/zephraArms.tres")
			arms.position += Vector2(0, -1)
		if i == 1:
			sprite.frames = load("res://spriteframes/gab.tres")
			arms.frames = load("res://spriteframes/gabArms.tres")
			arms.position += Vector2(0, -2)
	
	if type == "madmax":
		bodyType = 0
		health = 300
		healthMax = 300
		var newsprite = AnimatedSprite.new()
		self.add_child(newsprite)
		arms = newsprite
		
		arms.animation = "idle"
		arms.flip_h = true
		
		arms.connect("animation_finished", self, "stopArms")
		
		sprite.frames = load("res://spriteframes/alexander.tres")
		arms.frames = load("res://spriteframes/alexanderArms.tres")
		arms.position += Vector2(0, -2)

func getInputs(delta):
	var dir2player = player.global_position - self.global_position
	if !attacking:
		if type == "melee":
			inputs = dir2player.normalized()
			
			if dir2player.distance_to(Vector2.ZERO) < 40:
				attack()
		if type == "swat":
			if dir2player.distance_to(Vector2.ZERO) < 70:
				inputs = -dir2player.normalized()
				arms.flip_v = dir2player.normalized().x > 0
			else:
				attack()
		if type == "madmax":
			if dir2player.distance_to(Vector2.ZERO) < 70:
				inputs = -dir2player.normalized()
				arms.flip_v = dir2player.normalized().x > 0
			elif dir2player.distance_to(Vector2.ZERO) > 170:
				inputs = dir2player.normalized()
			else:
				attack()
		
		if arms:
			arms.flip_v = dir2player.normalized().x < 0
#			sprite.flip_h = dir2player.normalized().x < 0
	if type == "swat" or type == "madmax":
		sprite.flip_h = dir2player.normalized().x > 0
		if arms: arms.rotation = lerp_angle(arms.rotation, dir2player.normalized().angle(), delta * 5)
		$particles.position = Vector2.ONE.rotated(arms.rotation - 0.7854) * 10 + Vector2(0, -1)
		$particles.process_material.direction = Vector3($particles.position.x, $particles.position.y, 0)

func attack():
	if type == "melee":
		get_parent().playSound("coup_ventre_enemies.wav")
		meleeAttack(player.global_position - self.global_position, 0.3, 0.4)
	if type == "swat" or type == "madmax":
		get_parent().playSound("gun.wav")
		arms.animation = "attack"
		arms.playing = true
		$particles.emitting = true
		
		if type == "madmax":
			shootAttack(Vector2.ONE.rotated(arms.rotation - 0.7854), 10, 0.1 , false)
		else: shootAttack(Vector2.ONE.rotated(arms.rotation - 0.7854))

func _draw_line():
	draw_line(Vector2.ZERO, Vector2(50, 50), Color(255, 0, 0), 1)

func die():
	print(self.name + " is dead.")
	get_parent().reduceEnemyCount()
	var s = fx.instance()
	get_parent().add_child(s)
	s.global_position = self.position - Vector2(8, 8)
	createBody(type + str(bodyType))
	queue_free()

func _on_sprite_animation_finished():
	if attacking: $sprite.animation = "idle"

func stopArms():
	arms.animation = "idle"

func move(delta):
	# - SPRITE
	if type == "madmax":
		if inputs.x != 0: sprite.flip_h = inputs.x > 0
	else:
		if inputs.x != 0: sprite.flip_h = inputs.x < 0
	
	# - MVT
	velocity += inputs * accel * delta
	velocity *= friction
	
	velocity = move_and_slide(velocity)

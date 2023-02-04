extends Entity

var dashPower = 700
var dashCooldownMax = 1
var dashCooldown = 0
var dashing = false

func _ready():
	attack = 100
	accel = Vector2(1000, 1000)
	sprite = $sprite
	healthColor = Color(0, 255, 0)
	makeHeart()

func getInputs(delta):
	# - MOVEMENT
	if !attacking:
		if Input.is_action_pressed("left"):
			inputs.x -= 1
		if Input.is_action_pressed("right"):
			inputs.x += 1
		if Input.is_action_pressed("up"):
			inputs.y -= 1
		if Input.is_action_pressed("down"):
			inputs.y += 1
		
		if Input.is_action_just_pressed("dash") and dashCooldown >= dashCooldownMax:
			dash()
			dashCooldown = 0
	
		# - ATTACK
		if Input.is_action_just_pressed("attack"):
			attack()
	
	dashCooldown += delta
	if dashCooldown > dashCooldownMax: dashCooldown = dashCooldownMax

func _draw():
	drawHealthBar()
	draw_rect(Rect2(-10, -20, dashCooldown/dashCooldownMax*20,1), Color(255, 255, 255))

func attack():
	meleeAttack(get_mouse_position_actual(), 0.3, 0)

func get_mouse_position_actual():
	return get_global_mouse_position() - self.global_position - Vector2(256, 153)

func _on_sprite_animation_finished():
	$sprite.animation = "idle"

func dash():
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

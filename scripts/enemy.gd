extends Entity

var player = null
var type = "melee"
var arms = null

func _ready():
	sprite = $sprite
	attack = 10
	makeHeart()

func setType(t):
	type = t
	if type == "melee":
		sprite.frames = load("res://spriteframes/titouan.tres")
	if type == "swat":
		sprite.frames = load("res://spriteframes/zephra.tres")
		var newsprite = AnimatedSprite.new()
		self.add_child(newsprite)
		arms = newsprite
		arms.frames = load("res://spriteframes/zephraArms.tres")
		arms.animation = "idle"
		arms.flip_h = true
		arms.position += Vector2(0, -1)
		arms.connect("animation_finished", self, "stopArms")
		

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
		
		if arms:
			arms.flip_v = dir2player.normalized().x < 0
#			sprite.flip_h = dir2player.normalized().x < 0
	if type == "swat":
		sprite.flip_h = dir2player.normalized().x > 0
		if arms: arms.rotation = lerp_angle(arms.rotation, dir2player.normalized().angle(), delta * 5)
		$particles.position = Vector2.ONE.rotated(arms.rotation - 0.7854) * 10 + Vector2(0, -1)
		$particles.process_material.direction = Vector3($particles.position.x, $particles.position.y, 0)

func attack():
	if type == "melee": meleeAttack(player.global_position - self.global_position, 0.3, 0.4)
	if type == "swat":
		arms.animation = "attack"
		arms.playing = true
		$particles.emitting = true
		shootAttack(Vector2.ONE.rotated(arms.rotation - 0.7854))

func _draw_line():
	draw_line(Vector2.ZERO, Vector2(50, 50), Color(255, 0, 0), 1)

func die():
	print(self.name + " is dead.")
	get_parent().reduceEnemyCount()
	var s = fx.instance()
	get_parent().add_child(s)
	s.global_position = self.position - Vector2(8, 8)
	queue_free()

func _on_sprite_animation_finished():
	$sprite.animation = "idle"

func stopArms():
	arms.animation = "idle"

extends Entity

var player = null

func _ready():
	sprite = $sprite
	attack = 5

func _draw():
	# - DEBUG
#	draw_circle(Vector2.ZERO, 16, Color(255, 0, 0))
	pass

func getInputs():
	if !attacking:
		var dir2player = player.global_position - self.global_position
		inputs = dir2player.normalized()
		
		if dir2player.distance_to(Vector2.ZERO) < 40:
			attack()

func attack():
	meleeAttack(player.global_position - self.global_position, 0.3, 0.4)

func _draw_line():
	draw_line(Vector2.ZERO, Vector2(50, 50), Color(255, 0, 0), 1)

func die():
	print(self.name + " is dead.")
	get_parent().reduceEnemyCount()
	queue_free()


func _on_sprite_animation_finished():
	$sprite.animation = "idle"

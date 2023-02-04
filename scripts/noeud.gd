extends Node2D

signal unlock_ability
signal send_desc(id)

var unlocked = false
var choosen = false

func _ready():
	if get_parent().choosen:
		unlocked = true

func _draw():
	for child in get_children():
		if child is Node2D:
			if choosen:
				draw_line(Vector2.ZERO, child.position, Color(255, 255, 0), 2)
			else:
				draw_line(Vector2.ZERO, child.position, Color(155, 255, 255), 2)

func _process(delta):
	if choosen:
		self.self_modulate = Color(255, 255, 0)
	elif get_mouse_position_actual().distance_to(global_position) < 16:
		emit_signal("send_desc", name)
		
		
		if Input.is_action_just_pressed("click") and unlocked and !choosen:
			choosen = true
			Global.active_upgrades.append(name)
			print(Global.active_upgrades)
			print(name + " is unlocked.")
			emit_signal("unlock_ability")
	
		if !unlocked:
			self.self_modulate = Color(255, 0, 0)
		else:
			self.self_modulate = Color(0, 80, 0)
	
	else:
		self.self_modulate = Color(255, 255, 255)
	update()
#	$test.global_position = get_mouse_position_actual()
	$sprite.modulate = self_modulate

func get_mouse_position_actual():
#	print(get_global_mouse_position())
	return get_global_mouse_position()/2 + Vector2(-130, -75) + get_player_position()/2

func get_player_position():
	return get_parent().get_player_position()

func show_desc(id):
	emit_signal("send_desc", id)

func ability_is_unlocked():
	emit_signal("unlock_ability")

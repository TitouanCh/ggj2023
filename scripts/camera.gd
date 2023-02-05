extends Camera2D

var Tdelta = 0

func _process(delta):
#	if Global.active_upgrades.has("Drunk"):
#		offset.y = cos(Tdelta * 5) * 10 + -150
#		rotation_degrees = (sin(Tdelta) * 20) - 10
	Tdelta += delta

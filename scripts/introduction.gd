extends Node2D

var slide = 0
var Tdelta = 0

func _process(delta):
	if Input.is_action_just_pressed("click") and slide == 0:
		slide = 1
		$sprite.visible = true
		get_parent().startMusic()
		changeSlide(slide)
	
	if slide > 0 and Tdelta > 2:
		slide += 1
		Tdelta = 0
		changeSlide(slide)
		if slide == 4:
			get_parent().startGeneration(0)
			get_parent().intro = null
			self.queue_free()
	
	
	if slide > 0:
		Tdelta += delta
		$title.rect_position = $title.rect_position.linear_interpolate(Vector2(164, 220), delta * 4)


func changeSlide(s):
	slide = s
	
	if slide == 1:
		$sprite.animation = "keys"
		$title.bbcode_text = "[wave amp=20 freq=2][center]To Move[/center][/wave]"
	
	if slide == 2:
		$sprite.animation = "souris1"
		$title.bbcode_text = "[wave amp=20 freq=2][center]To Attack[/center][/wave]"
	
	if slide == 3:
		$sprite.animation = "souris2"
		$title.bbcode_text = "[wave amp=20 freq=2][center]To Dash[/center][/wave]"

extends Node2D

func _ready():
	$sprite.playing = true

func _on_sprite_animation_finished():
	queue_free()

func _process(delta):
	z_index = position.y

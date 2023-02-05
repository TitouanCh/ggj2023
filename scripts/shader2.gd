extends ColorRect

#
func _process(delta):
	if get_parent().get_parent().tree or get_parent().get_parent().intro: self.visible = true
	else: self.visible = false

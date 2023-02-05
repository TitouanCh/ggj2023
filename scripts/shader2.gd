extends ColorRect

#
func _process(delta):
	if get_parent().get_parent().tree: self.visible = true
	else: self.visible = false

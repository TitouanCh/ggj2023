extends ColorRect


func _process(delta):
	if Global.active_upgrades.has("Drunk"): self.visible = false

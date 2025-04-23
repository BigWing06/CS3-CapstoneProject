extends Sprite2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var adjacent = (self.position.x+(global.player.position.x-(get_viewport_rect().size.x/2))-global.world.base.position.x)
	var opposite = (self.position.y+(global.player.position.y-(get_viewport_rect().size.y/2))-global.world.base.position.y)
	rotation = cos(adjacent/opposite)

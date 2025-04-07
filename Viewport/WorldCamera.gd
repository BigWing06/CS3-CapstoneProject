extends Camera2D

func _process(delta: float) -> void:
	if global.player: ###
		self.position=global.player.position

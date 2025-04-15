extends Camera2D


func _process(delta: float) -> void:
	if get_node("/root/Main/ViewportControl/WorldViewportContainer/WorldViewport/World/Player"):
		self.position = get_node("/root/Main/ViewportControl/WorldViewportContainer/WorldViewport/World/Player").position

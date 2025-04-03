extends Label

func _process(delta: float) -> void:
	position = get_global_mouse_position()
	position.y = position.y - get_global_rect().size.y - 10
	position.x += 10

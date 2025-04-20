extends Label

#This script sets the positon of the hover text to be where the user's pointner is

func _process(delta: float) -> void:
	position = get_global_mouse_position()
	position.y = position.y - get_global_rect().size.y - 14 #Adds the Y offset for the label
	position.x += 14 #Adds the X offset for the label

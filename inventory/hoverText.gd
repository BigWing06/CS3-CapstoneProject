extends Label

#This script sets the positon of the hover text to be where the user's pointner is
@export var _windowPadding:float = 0.05 # The padding required between the hover text and the viewport as a percent of the label
func _process(delta: float) -> void:
	if ($TextureRect.size.x*(1+_windowPadding)) < get_viewport_rect().size.x-get_global_mouse_position().x: # If the label will be outside of the viewport flip its location so it is not
		position = get_global_mouse_position()
		position.y = position.y - get_global_rect().size.y - 14 #Adds the Y offset for the label
		position.x += 14 #Adds the X offset for the label
	else:
		position = get_global_mouse_position()
		position.y = position.y - get_global_rect().size.y - 14 #Adds the Y offset for the label
		position.x -= $TextureRect.size.x #Adds the X offset for the label

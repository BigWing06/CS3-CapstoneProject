extends Node2D

func display(_healthAmount:float, _location: Vector2):
	position = _location # The location to put this node
	$Control/Amount.text = str(_healthAmount) # Sets the health displayed
	if _healthAmount<0:
		$Control/Amount.add_theme_color_override("font_color", "#FF0000")
	else:
		$Control/Amount.add_theme_color_override("font_color", "#00FF00")
	$AnimationPlayer.play("Display") # Plays the animation

func _on_animation_player_animation_finished(anim_name: StringName) -> void: # When the animation is done, delete the node
	queue_free()

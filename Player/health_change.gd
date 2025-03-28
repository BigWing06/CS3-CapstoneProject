extends Node2D

func display(_healthAmount:float, _location: Vector2):
	position = _location # The location to put this node
	$Control/Amount.text = str(_healthAmount) # Sets the health displayed
	$AnimationPlayer.play("Display") # Plays the animation

func _on_animation_player_animation_finished(anim_name: StringName) -> void: # When the animation is done, delete the node
	queue_free()

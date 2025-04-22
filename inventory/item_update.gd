extends TextureRect

var resource:String = "wood"
var amount:int = 10

func _ready() -> void:
	if amount>0: # If positive adds + sign and then sets label value, otherwise sets label value
		$HBoxContainer/Label.text = "+" + str(amount)+" " + utils.resourceJSON[resource]["name"]
	else:
		$HBoxContainer/Label.text = str(amount)+" " + utils.resourceJSON[resource]["name"]
		
	$HBoxContainer/TextureRect.texture = utils.loadImage(utils.appendToPath(utils.resourceImageRootPath,resource+".png")) # Sets the texture value
	$DurationTimer.start() # Starts the disappear timer



func _on_duration_timer_timeout() -> void: # When timer is over start fade animation
	$AnimationPlayer.play("FadeAway")


func _on_animation_player_animation_finished(anim_name: StringName) -> void: # After animations delete player
	queue_free()

extends TextureProgressBar

func _ready() -> void:
	self.value = 100
func start():
	var _timeout = utils.readFromJSON(utils.toolsJSON[global.player.getMode()], "timeout")
	if _timeout:
		$AnimationPlayer.speed_scale = 1 / _timeout
		$AnimationPlayer.play("Cooldown")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	self.value = 100

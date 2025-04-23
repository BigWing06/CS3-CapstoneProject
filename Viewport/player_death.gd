extends Control

func _ready() -> void:
	visible=false
func showDeathScreen():
	visible=true
	$AnimationPlayer.play("Fade")
	$ColorRect/AnimatedSprite2D.play("walk")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$ColorRect/AnimatedSprite2D.stop()
	visible=false

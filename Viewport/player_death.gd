extends Control

func _ready() -> void:
	modulate = Color8(0,0,0,0)
func showDeathScreen():
	$AnimationPlayer.play("Fade")
	$ColorRect/AnimatedSprite2D.play("walk")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$ColorRect/AnimatedSprite2D.stop()

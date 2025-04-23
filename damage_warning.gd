extends Control

func _ready() -> void:
	visible = false
func play():
	visible=true
	$AnimationPlayer.play("Fade")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible=false

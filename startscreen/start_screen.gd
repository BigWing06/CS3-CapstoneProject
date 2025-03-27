extends Control

var screen_texture = preload("res://Player/screen.png")
var square_texture = preload("res://Player/square.png")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Player/player.tscn")


func _on_end_button_pressed() -> void:
	get_tree().quit()


func _on_switch_button_pressed() -> void:
	pass

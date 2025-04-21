extends Control


func _on_start_button_pressed() -> void:
	AudioController.play_menu()
	get_tree().change_scene_to_file("res://Viewport/Main.tscn")


func _on_end_button_pressed() -> void:
	AudioController.play_menu()
	get_tree().quit()

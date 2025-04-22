extends Control

func _ready() -> void:
	for child in $Animations/Enemies.get_children():
		child.sprite_frames = load("res://Enemy/Animations/"+utils.getEnemies().pick_random()+"animations.tres")
	for child in get_tree().get_nodes_in_group("StartScreenAnimations"):
		child.play()
func _on_start_button_pressed() -> void:
	AudioController.play_menu()
	get_tree().change_scene_to_file("res://Viewport/Main.tscn")


func _on_end_button_pressed() -> void:
	AudioController.play_menu()
	get_tree().quit()

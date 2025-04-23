extends Control
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://startscreen/start_screen.tscn")

func _ready() -> void:
	for child in $Animations/Enemies.get_children():
		child.sprite_frames = load("res://Enemy/Animations/beaveranimations.tres")
	for child in get_tree().get_nodes_in_group("StartScreenAnimations"):
		child.play()
	$Subtitle.text = utils.readJSON("res://deathScreen/snarkyText.json")["subtitles"].pick_random()
func _on_start_button_pressed() -> void:
	AudioController.play_menu()
	get_tree().change_scene_to_file("res://Viewport/Main.tscn")

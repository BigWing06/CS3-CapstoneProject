extends Control

var b1
var b2
var b3


func _on_start_button_pressed() -> void:
	if b1:
		$HBoxContainer/Character1.icon.resource_path = global.characterTexture
	elif b2:
		$HBoxContainer/Character2.icon.resource_path = global.characterTexture
	elif b3:
		$HBoxContainer/Character3.icon.resource_path = global.characterTexture
	global.main.startGame()


func _on_end_button_pressed() -> void:
	get_tree().quit()


func _on_character_1_pressed() -> void:
	b1 = true
	$HBoxContainer/Character1.disabled = true
	b2 = false
	$HBoxContainer/Character2.disabled = false
	b3 = false
	$HBoxContainer/Character3.disabled = false
	

func _on_character_2_pressed() -> void:
	b1 = false
	$HBoxContainer/Character1.disabled = false
	b2 = true
	$HBoxContainer/Character2.disabled = true
	b3 = false
	$HBoxContainer/Character3.disabled = false

func _on_character_3_pressed() -> void:
	b1 = false
	$HBoxContainer/Character1.disabled = false
	b2 = false
	$HBoxContainer/Character2.disabled = false
	b3 = true
	$HBoxContainer/Character3.disabled = true

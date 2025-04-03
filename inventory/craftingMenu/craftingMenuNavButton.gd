extends ColorRect

signal bttnClicked
@export var bttnText:String

func _ready() -> void:
	$Button.text = bttnText

func _on_button_pressed() -> void:
	bttnClicked.emit()

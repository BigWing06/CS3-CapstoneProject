extends TextureButton

signal bttnClicked
@export var bttnText:String

func _on_pressed() -> void:
	bttnClicked.emit()

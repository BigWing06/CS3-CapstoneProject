extends TextureButton

signal bttnClicked
@export var bttnText:String
@export var ICON_PATH:String

func _ready() -> void:
	if ICON_PATH != null:
		$Icon.texture = load(ICON_PATH)
func _on_pressed() -> void:
	bttnClicked.emit()

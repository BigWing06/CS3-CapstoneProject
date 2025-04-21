extends TextureButton

@export var LABEL_TEXT: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = LABEL_TEXT

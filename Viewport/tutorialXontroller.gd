extends Control


# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func hideMessage():
	input.leftClick.disconnect(hide)
	input.pauseMode(false)
	hide()

func displayMessage(imagePath):
	show()
	input.pauseMode(true)
	$TextureRect.texture = utils.loadImage(imagePath)
	input.leftClick.connect(hideMessage)

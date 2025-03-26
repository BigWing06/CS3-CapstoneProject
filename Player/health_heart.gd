extends Control
func _ready():
	halfHeart()
func halfHeart():
	$HeartSprite.texture=ResourceLoader.load("res://Player/HalfHeart.png")
func fullHeart():
	$HeartSprite.texture=ResourceLoader.load("res://Player/FullHeart.png")

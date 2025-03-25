extends Sprite2D

var screen_texture = preload("res://Player/screen.png")
var square_texture = preload("res://Player/square.png")

func _process(delta):
		if texture == square_texture:
			texture = screen_texture
		else:
			texture = square_texture

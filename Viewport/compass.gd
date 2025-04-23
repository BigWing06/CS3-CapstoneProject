extends Sprite2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var adjacent = abs(global.player.position.x-global.world.base.position.x)
	var hypotenuse = sqrt(((global.player.position.y-global.world.base.position.y)**2) + ((global.player.position.x-global.world.base.position.x)**2))
	rotation = asin(adjacent/hypotenuse)

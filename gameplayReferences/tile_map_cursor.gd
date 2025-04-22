extends TextureRect
func _ready() -> void:
	input.mouseModeChange.connect(onModeChange)

func _process(delta: float) -> void:
	var tileMap = global.world.get_node("TileMaps").getMainTilemap()
	position = floor((get_global_mouse_position())/tileMap.tile_set.tile_size.x)*tileMap.tile_set.tile_size.x
	
func onModeChange(mode):
	if mode != "tileMap":
		queue_free()

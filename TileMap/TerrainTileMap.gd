extends TileMapLayer

var _noise = FastNoiseLite.new()
var _width = 50
var _height = 50
func _ready() -> void:
	_noise.seed = 32432
	_generate_chunk(position)

func _generate_chunk(position):
	var _tile_pos = local_to_map(position)
	var _snowToSet = []
	var _waterToSet = []
	for x in range(_width):
		for y in range(_height):
			var _randNum = _noise.get_noise_2d(_tile_pos.x-_width/2+x,_tile_pos.y-_height/2+y)*10
			#var _randNum = randf()*10
			if _randNum >1:
				_snowToSet.append(Vector2i(x,y))
			else:
				_waterToSet.append(Vector2i(x,y))
	set_cells_terrain_connect(_snowToSet,0,0)
	for pos in _waterToSet:
		set_cell(pos,0,Vector2i(0,4))

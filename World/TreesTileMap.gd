extends TileMapLayer

var _width = 50
var _height = 50

func _ready() -> void:
	_generate_chunk(position)
	

func _generate_chunk(position):
	var _tile_pos = local_to_map(position)
	var _treeOptions = [Vector2i(0,1),Vector2i(1,2),Vector2i(0,3),Vector2i(1,3),Vector2i(2,4),Vector2i(3,4)]
	for x in range(_width):
		for y in range(_height):
			var _randNum = randf()
			var _cellData = get_node(global.worldPath+"/TileMaps/Snow").get_cell_tile_data(Vector2i(x,y))
			if _randNum >0 and _cellData.terrain_set != 0:
				set_cell(Vector2i(x,y),1,_treeOptions.pick_random())

extends TileMapLayer

var _width = 50 # width of the chunk
var _height = 50 # height of the chunk
var _rand = RandomNumberGenerator.new() # generator for random numbers

func _ready() -> void:
	_rand.seed = 1234 # seed for generator
	_generate_chunk(position)
	

func _generate_chunk(position): # generates trees based on position
	var _tile_pos = local_to_map(position)
	var _treeOptions = [Vector2i(0,1),Vector2i(1,2),Vector2i(0,3),Vector2i(1,3),Vector2i(2,4),Vector2i(3,4)] # options for types of trees
	for x in range(_width):
		for y in range(_height):
			var _randNum = _rand.randf_range(0,1)
			print(_randNum)
			var _cellData = get_node(global.worldPath+"/TileMaps/Snow").get_cell_tile_data(Vector2i(x,y)) # the terrain type at this position
			if _randNum >.8 and _cellData.terrain_set == 0: # if the terrain type is snow, and the random number is greater than 0.8
				set_cell(Vector2i(x,y),1,_treeOptions[_rand.randi_range(0,len(_treeOptions)-1)]) # set the tile to a random type of tree

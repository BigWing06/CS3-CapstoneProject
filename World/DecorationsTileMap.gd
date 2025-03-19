extends TileMapLayer

var _width = 50 # width of the chunk to generate
var _height = 50 # height of the chunk to generate
var _rand = RandomNumberGenerator.new() # random generator object

func _ready() -> void:
	_rand.seed = global.WORLD_SEED # seed for the chunk
	_generate_chunk(position)
	

func _generate_chunk(position): # displays decorations based on position
	var _tile_pos = local_to_map(position)
	var _flowerOptions = [Vector2i(1,1),Vector2i(2,1),Vector2i(3,1),Vector2i(4,2),Vector2i(5,2),Vector2i(6,2)] # all of the options for types of flowers
	for x in range(_width):
		for y in range(_height):
			var _randNum = randf()
			var _cellData = get_node(global.worldPath+"/TileMaps/Snow").get_cell_tile_data(Vector2i(x,y)) # the type of terrain tile at (x,y)
			if _randNum >.8 and _cellData.terrain_set == 0: # if the tile is snow and the random number is larger than 0.8
				set_cell(Vector2i(x,y),0,_flowerOptions[_rand.randi_range(0,len(_flowerOptions)-1)]) # sets the cell to a random type of decoration

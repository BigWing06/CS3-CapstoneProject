extends TileMapLayer

var _noise = FastNoiseLite.new() # noise generator
var _width = 50 # width of the chunk
var _height = 50 # height of the chunk
func _ready() -> void:
	_noise.seed = global.WORLD_SEED # seed for the generator
	_generate_chunk(position)

func _generate_chunk(position): # generates the terrain based on position
	var _tile_pos = local_to_map(position)
	var _snowToSet = [] # tiles to set to snow
	var _waterToSet = [] # tiles to set to water
	for x in range(_width):
		for y in range(_height):
			var _randNum = _noise.get_noise_2d(_tile_pos.x-_width/2+x,_tile_pos.y-_height/2+y)*10 # gets random number from noise
			if _randNum >1:
				_snowToSet.append(Vector2i(x,y)) # if the random number is greater than 1 add the tile position to the list of snow tiles
			else:
				_waterToSet.append(Vector2i(x,y)) # otherwise add it to the list of water tiles
	set_cells_terrain_connect(_snowToSet,0,0) # sets all of the snow array tiles to actually be snow
	for pos in _waterToSet:
		set_cell(pos,0,Vector2i(0,4)) # set all of the water array tiles to water

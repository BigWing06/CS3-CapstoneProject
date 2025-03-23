extends Node2D


# Called when the node enters the scene tree for the first time.
var _terrainNoise = FastNoiseLite.new() # noise generator for terrain tilemap
var _treeRand = RandomNumberGenerator.new() # random number generator for tree tilemap
var _flowerRand = RandomNumberGenerator.new() # random generator object
func _ready() -> void:
	_terrainNoise.seed = global.WORLD_SEED
	_treeRand.seed = global.WORLD_SEED 
	_flowerRand.seed = global.WORLD_SEED
	_generate_chunk(position, Vector2(50, 50))
	
func getMainTilemap() -> TileMapLayer: #This function returns the terrain tilemap node for reference outside of this scene
	return get_node("Terrain")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _generate_chunk(position: Vector2i,chunkSize: Vector2i):
	_generate_terrain_chunk(position, chunkSize)
	_generate_tree_chunk(position, chunkSize)
	_generate_decorations_chunk(position, chunkSize)
	
func _generate_terrain_chunk(position: Vector2i, chunkSize: Vector2i): # generates the terrain based on position
	var _tile_pos = $Terrain.local_to_map(position)
	var _snowToSet = [] # tiles to set to snow
	var _waterToSet = [] # tiles to set to water
	for x in range(chunkSize.x):
		for y in range(chunkSize.y):
			var _randNum = _terrainNoise.get_noise_2d(_tile_pos.x-chunkSize.x/2+x,_tile_pos.y-chunkSize.y/2+y)*10 # gets random number from noise
			if _randNum >1:
				_snowToSet.append(Vector2i(x,y)) # if the random number is greater than 1 add the tile position to the list of snow tiles
			else:
				_waterToSet.append(Vector2i(x,y)) # otherwise add it to the list of water tiles
	$Terrain.set_cells_terrain_connect(_snowToSet,0,0) # sets all of the snow array tiles to actually be snow
	for pos in _waterToSet:
		$Terrain.set_cell(pos,0,Vector2i(0,4)) # set all of the water array tiles to water

func _generate_tree_chunk(position: Vector2i, chunkSize: Vector2i):
	var _tile_pos = $Trees.local_to_map(position)
	var _treeOptions = [Vector2i(0,1),Vector2i(1,2),Vector2i(0,3),Vector2i(1,3),Vector2i(2,4),Vector2i(3,4)] # options for types of trees
	for x in range(chunkSize.x):
		for y in range(chunkSize.y):
			var _randNum = _treeRand.randf_range(0,1)
			var _cellData = $Terrain.get_cell_tile_data(Vector2i(x,y)) # the terrain type at this position
			if _randNum >.8 and _cellData.terrain_set == 0: # if the terrain type is snow, and the random number is greater than 0.8
				$Trees.set_cell(Vector2i(x,y),1,_treeOptions[_treeRand.randi_range(0,len(_treeOptions)-1)]) # set the tile to a random type of tree
				
func _generate_decorations_chunk(position: Vector2i, chunkSize: Vector2i):
	var _tile_pos = $Decorations.local_to_map(position)
	var _flowerOptions = [Vector2i(1,1),Vector2i(2,1),Vector2i(3,1),Vector2i(4,2),Vector2i(5,2),Vector2i(6,2)] # all of the options for types of flowers
	for x in range(chunkSize.x):
		for y in range(chunkSize.y):
			var _randNum = _flowerRand.randf_range(0,1)
			var _cellData = $Terrain.get_cell_tile_data(Vector2i(x,y)) # the terrain type at this position
			if _randNum >.8 and _cellData.terrain_set == 0: # if the terrain type is snow, and the random number is greater than 0.8
				$Decorations.set_cell(Vector2i(x,y),1,_flowerOptions[_flowerRand.randi_range(0,len(_flowerOptions)-1)]) # set the tile to a random type of tree

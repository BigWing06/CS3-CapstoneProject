extends Node2D

@export var chunkSize: Vector2i #Variable that determines how big a chunk is
@export var chunkPlayerBuffer: int #Variable that determines how many chunks are rendered around the chunk the player is in

@onready var inventory = preload("res://inventory/inventory.gd").new()

# Called when the node enters the scene tree for the first time.
var _terrainNoise = FastNoiseLite.new() # noise generator for terrain tilemap
var _treeRand = RandomNumberGenerator.new() # random number generator for tree tilemap
var _flowerRand = RandomNumberGenerator.new() # random generator object
var _resourceRand = RandomNumberGenerator.new() # random generator for resources

var _renderedChunks = [] #list that keeps track of the chunks that are rendered
var _initalChunks = [Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1)]

var _localPosition #used for collision
var _resource #variable passed through inventory method

func _ready() -> void:
	global.WORLD_SEED = 3894
	_terrainNoise.seed = global.WORLD_SEED
	_treeRand.seed = global.WORLD_SEED 
	_flowerRand.seed = global.WORLD_SEED
	for chunk in _initalChunks:
		_generate_chunk(chunk)
	
func getMainTilemap() -> TileMapLayer: #This function returns the terrain tilemap node for reference outside of this scene
	return get_node("Terrain")
	
func getChunk(position: Vector2) -> Vector2i: #Returns the chunk that the inputted cordinates are contained in
	var tileMapPos = $Terrain.local_to_map(to_local(position))
	return Vector2i(floor(tileMapPos.x/chunkSize.x), floor(tileMapPos.y/chunkSize.y))

func playerRenderNeighborChunks(playerChunk: Vector2i): #This function should be called by player scene instances so that more of the world is rendered when they leave the rendered area
	for x in range(playerChunk.x-chunkPlayerBuffer, playerChunk.x+chunkPlayerBuffer):
		for y in range(playerChunk.y-chunkPlayerBuffer, playerChunk.y+chunkPlayerBuffer):
			var chunk = Vector2i(x, y)
			if chunk not in _renderedChunks:
				_generate_chunk(chunk)

func _generate_chunk(chunkPosition: Vector2i):
	_renderedChunks.append(chunkPosition)
	var position = Vector2i(chunkPosition.x * chunkSize.x, chunkPosition.y * chunkSize.y)
	_generate_terrain_chunk(position, chunkSize)
	_generate_tree_chunk(position, chunkSize)
	_generate_decorations_chunk(position, chunkSize)
	
func _generate_terrain_chunk(position: Vector2i, chunkSize: Vector2i): # generates the terrain based on position
	var _tile_pos = $Terrain.local_to_map(position)
	var _snowToSet = [] # tiles to set to snow
	var _waterToSet = [] # tiles to set to water
	for x in range(chunkSize.x):
		for y in range(chunkSize.y):
			var _randNum = _terrainNoise.get_noise_2dv(Vector2(position)+Vector2(_tile_pos.x-chunkSize.x/2+x,_tile_pos.y-chunkSize.y/2+y))*10 # gets random number from noise
			if _randNum >1:
				_snowToSet.append(position+Vector2i(x,y)) # if the random number is greater than 1 add the tile position to the list of snow tiles
			else:
				_waterToSet.append(position+Vector2i(x,y)) # otherwise add it to the list of water tiles
	$Terrain.set_cells_terrain_connect(_snowToSet,0,0) # sets all of the snow array tiles to actually be snow
	for pos in _waterToSet:
		$Terrain.set_cell(pos,0,Vector2i(0,4)) # set all of the water array tiles to water

func _generate_tree_chunk(position: Vector2i, chunkSize: Vector2i):
	var _tile_pos = $Trees.local_to_map(position)
	var _treeOptions = [Vector2i(0,0),Vector2i(0,2),Vector2i(1,0),Vector2i(1,1),Vector2i(1,2),Vector2i(2,0),Vector2i(2,1),Vector2i(2,2)] # options for types of trees
	for x in range(chunkSize.x):
		for y in range(chunkSize.y):
			var _randNum = _treeRand.randf_range(0,1)
			var _cellData = $Terrain.get_cell_tile_data(position+Vector2i(x,y)) # the terrain type at this position
			if _randNum > .95 and _cellData.terrain_set == 0: # if the terrain type is snow, and the random number is greater than 0.8
				$Trees.set_cell(position+Vector2i(x,y),1,_treeOptions[_treeRand.randi_range(0,len(_treeOptions)-1)]) # set the tile to a random type of tree
				
func _generate_decorations_chunk(position: Vector2i, chunkSize: Vector2i):
	var _tile_pos = $Decorations.local_to_map(position)
	var _flowerOptions = [Vector2i(1,1),Vector2i(2,1),Vector2i(3,1),Vector2i(4,2),Vector2i(5,2),Vector2i(6,2)] # all of the options for types of flowers
	for x in range(chunkSize.x):
		for y in range(chunkSize.y):
			var _randNum = _flowerRand.randf_range(0,1)
			var _cellData = $Terrain.get_cell_tile_data(position+Vector2i(x,y)) # the terrain type at this position
			if _randNum >.8 and _cellData.terrain_set == 0: # if the terrain type is snow, and the random number is greater than 0.8
				$Decorations.set_cell(position+Vector2i(x,y),1,_flowerOptions[_flowerRand.randi_range(0,len(_flowerOptions)-1)]) # set the tile to a random type of tree

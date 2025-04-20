extends Node

var towerImageRootPath = "res://gameplayReferences/towerIcons/" #Path to folder that contains all of the tower art
var resourceImageRootPath = "res://gameplayReferences/resourceIcons" #Path to folder that contains all of the tower art
var enemyAnimationRootPath = "res://Enemy/Animations"

var fileNotFound = preload("res://fileNotFound.png")

var towerTypesJSON
var resourceJSON
var enemyJSON
var attackJSON
var toolsJSON

func _ready() -> void:
	towerTypesJSON = readJSON("res://gameplayReferences/towerTypes.json")
	resourceJSON = readJSON("res://gameplayReferences/resources.json")
	enemyJSON = readJSON("res://gameplayReferences/enemyTypes.json")
	attackJSON = readJSON("res://gameplayReferences/attackTypes.json")
	toolsJSON = readJSON("res://gameplayReferences/tools.json")
	
func readJSON(path):
	var _JSON = FileAccess.get_file_as_string(path)
	var _formattedJSON = JSON.parse_string(_JSON)
	return _formattedJSON
	
func loadImage(path: String): #This function should be used to load in all images so that they get repalced with the file not found image
	var image = load(path)
	if (null == image):
		image = fileNotFound
	return image
	
func readFromJSON(_JSON:Dictionary, _key): #Function that allows you to read a value from a dictionary without the risk of causing an error, returns null if key doesn't exist
	if _key in _JSON.keys():
		return _JSON[_key]
	return null
	
func appendToPath(path:String, file: String): 
	return path + "/" + file

func randWeightedListSetup(_dict: Dictionary): # Takes in a dictionary (formatted "key": weight) and returns an array that you can get a random item from to do weighted selection
	var _weightedList = []
	for key in _dict.keys():
		for i in range(int(_dict[key])):
			_weightedList.append(key)
	return _weightedList
	
func getRandomRadiusPosition(position:Vector2, radius:int) -> Vector2: #Returns random position within certain radius of supplied position
	var _spawnAngle = randf() * TAU
	return Vector2( 
			cos(_spawnAngle)*radius,
			sin(_spawnAngle)*radius
		) + position

func getClosestNode(callerNode, nodeList): #Find the closetes node in NodeList to caller node
	if len(nodeList) != 0:
		var closestNode = nodeList[0]
		var closestPosition = callerNode.global_position.distance_to(nodeList[0].global_position)
		for node in nodeList:
			if callerNode.global_position.distance_to(node.global_position) < closestPosition:
				closestNode = node
		return closestNode
	return null

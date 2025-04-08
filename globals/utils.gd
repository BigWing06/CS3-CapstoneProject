extends Node

var towerImageRootPath = "res://gameplayReferences/towerIcons/" #Path to folder that contains all of the tower art
var resourceImageRootPath = "res://gameplayReferences/resourceIcons" #Path to folder that contains all of the tower art

var fileNotFound = preload("res://fileNotFound.png")

var towerTypesJSON
var resourceJSON
var enemyJSON
var attackJSON

func _ready() -> void:
	###Create common JSON reader function so to clean up this section
	var _towerTypesJSONPath = "res://gameplayReferences/towerTypes.json"
	var _towerTypesJSONText = FileAccess.get_file_as_string(_towerTypesJSONPath)
	towerTypesJSON = JSON.parse_string(_towerTypesJSONText)
	var _resourceJSONPath = "res://gameplayReferences/resources.json"
	var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
	resourceJSON = JSON.parse_string(_resourceJSONText)
	var _enemyJSONPath = "res://gameplayReferences/enemyTypes.json"
	var _enemyJSONText = FileAccess.get_file_as_string(_enemyJSONPath)
	enemyJSON = JSON.parse_string(_enemyJSONText)
	var _attackJSONPath = "res://gameplayReferences/attackTypes.json"
	var _attackJSONText = FileAccess.get_file_as_string(_attackJSONPath)
	attackJSON = JSON.parse_string(_attackJSONText)
	
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

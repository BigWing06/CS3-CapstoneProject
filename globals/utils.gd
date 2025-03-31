extends Node

var towerImageRootPath = "res://Tower/towerResources/" #Path to folder that contains all of the tower art

var fileNotFound = preload("res://fileNotFound.png")

var towerTypesJSON
var resourceJSON
var enemyJSON
func _ready() -> void:
	var _towerTypesJSONPath = "res://gameplayReferences/towerTypes.json"
	var _towerTypesJSONText = FileAccess.get_file_as_string(_towerTypesJSONPath)
	towerTypesJSON = JSON.parse_string(_towerTypesJSONText)
	var _resourceJSONPath = "res://gameplayReferences/resources.json"
	var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
	resourceJSON = JSON.parse_string(_resourceJSONText)
	var _enemyJSONPath = "res://gameplayReferences/enemyTypes.json"
	var _enemyJSONText = FileAccess.get_file_as_string(_enemyJSONPath)
	enemyJSON = JSON.parse_string(_enemyJSONText)
	
func loadImage(path: String): #This function should be used to load in all images so that they get repalced with the file not found image
	var image = load(path)
	if (null == image):
		image = fileNotFound
	return image

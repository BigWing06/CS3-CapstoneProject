extends Node

var _towerTypesJSON
var _resourceJSON
var _enemyJSON
func _ready() -> void:
	var _towerTypesJSONPath = "res://gameplayReferences/towerTypes.json"
	var _towerTypesJSONText = FileAccess.get_file_as_string(_towerTypesJSONPath)
	_towerTypesJSON = JSON.parse_string(_towerTypesJSONText)
	var _resourceJSONPath = "res://gameplayReferences/resources.json"
	var _resourceJSONText = FileAccess.get_file_as_string(_resourceJSONPath)
	_resourceJSON = JSON.parse_string(_resourceJSONText)
	var _enemyJSONPath = "res://gameplayReferences/enemyTypes.json"
	var _enemyJSONText = FileAccess.get_file_as_string(_enemyJSONPath)
	_enemyJSON = JSON.parse_string(_enemyJSONText)
	

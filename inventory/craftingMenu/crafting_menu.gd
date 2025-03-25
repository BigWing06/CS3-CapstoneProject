extends Control

var _towerListScene = preload("res://inventory/craftingMenu/craftingMenuTowerListInstance.tscn") #Reference to scene for the tower menu list
@onready var _towerDisplayList = $scrollContainer/towerDisplayList #Stores refence to towerDispalyList node for use later

var _towerTypesJSONPath = "res://gameplayReferences/towerTypes.json"
var _towerTypesJSONText = FileAccess.get_file_as_string(_towerTypesJSONPath)
var _towerTypesJSON = JSON.parse_string(_towerTypesJSONText)

func _ready() -> void:
	for key in _towerTypesJSON.keys():
		var towerListSceneInstance = _towerListScene.instantiate()
		towerListSceneInstance.update(_towerTypesJSON[key])
		_towerDisplayList.add_child(towerListSceneInstance)

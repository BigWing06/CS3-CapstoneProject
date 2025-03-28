extends Control

signal selectedTowerChanged(FOCUS_CLICK)

var _towerListScene = preload("res://inventory/craftingMenu/craftingMenuTowerListInstance.tscn") #Reference to scene for the tower menu list
@onready var _towerDisplayList = $scrollContainer/towerDisplayList #Stores refence to towerDispalyList node for use later

var _towerTypesJSONPath = "res://gameplayReferences/towerTypes.json"
var _towerTypesJSONText = FileAccess.get_file_as_string(_towerTypesJSONPath)
var _towerTypesJSON = JSON.parse_string(_towerTypesJSONText)
var _towerTypesList = _towerTypesJSON.keys()
var _selectedTowerType = 0

func _ready() -> void:
	set_focus_mode(FOCUS_NONE)
	for key in _towerTypesList: #Instances the craftingMenuTowerListInstance to create the list in the crafting menu
		var towerListSceneInstance = _towerListScene.instantiate()
		towerListSceneInstance.update(key, _towerTypesJSON[key])
		selectedTowerChanged.connect(towerListSceneInstance.selectedTowerUpdate)
		_towerDisplayList.add_child(towerListSceneInstance)
	selectedTowerChanged.emit(_towerTypesList[_selectedTowerType])
	
func _process(delta: float) -> void:
	#If statements to change the selected tower on mouse scroll
	if Input.is_action_just_pressed("craftingScrollDown"):
		_selectedTowerType = (_selectedTowerType + 1) % len(_towerTypesList)
		selectedTowerChanged.emit(_towerTypesList[_selectedTowerType])
	if Input.is_action_just_pressed("craftingScrollUp"):
		_selectedTowerType = (_selectedTowerType - 1) % len(_towerTypesList)
		selectedTowerChanged.emit(_towerTypesList[_selectedTowerType])
	if Input.is_action_just_pressed("toggleBuildMenu"):
		toggleMenu()
	
func _on_selected_tower_changed(tower: Variant) -> void:
	$Control/towerTitle.text = _towerTypesJSON[tower]['name']
		
func toggleMenu():
	visible = !visible
